#!/bin/bash
# File Auditor & Backup Tool - main script.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

TARGET_DIR="${1:-.}"
ACTION="$2"
BACKUP_DIR="$SCRIPT_DIR/backups"
LOG_FILE="$SCRIPT_DIR/auditor.log"

# Scan the target directory, list files/folders, and count them.
scan_directory() {
    local f files=0 dirs=0
    shopt -s nullglob
    for f in "$TARGET_DIR"/*; do
        if [ -d "$f" ]; then
            echo "[dir] ${f##*/}"
            dirs=$((dirs + 1))
        elif [ -f "$f" ]; then
            echo "[file] ${f##*/}"
            files=$((files + 1))
        fi
    done
    shopt -u nullglob
    echo "Files: $files Folders: $dirs"
    log_action "scan $TARGET_DIR (files=$files, folders=$dirs)"
}

# Print r/w/x flags per file and count unreadable/executable files.
permission_audit() {
    local f r w x unreadable=0 executable=0
    shopt -s nullglob
    for f in "$TARGET_DIR"/*; do
        [ -f "$f" ] || continue
        r="-"; w="-"; x="-"
        [ -r "$f" ] && r="r"
        [ -w "$f" ] && w="w"
        [ -x "$f" ] && x="x"
        echo "$r$w$x ${f##*/}"
        [ "$r" = "-" ] && unreadable=$((unreadable + 1))
        [ "$x" = "x" ] && executable=$((executable + 1))
    done
    shopt -u nullglob
    echo "Unreadable files: $unreadable Executable files: $executable"
    log_action "permission audit $TARGET_DIR (unreadable=$unreadable, executable=$executable)"
}

# Count files per extension (txt, log, sh, jpg, other) using an associative array.
extension_report() {
    local f name ext
    local -A counts=([txt]=0 [log]=0 [sh]=0 [jpg]=0 [other]=0)
    shopt -s nullglob
    for f in "$TARGET_DIR"/*; do
        [ -f "$f" ] || continue
        name="${f##*/}"
        ext="other"
        if [[ "$name" == *.* && "$name" != .* ]]; then
            ext="${name##*.}"
            ext="${ext,,}"
        fi
        case "$ext" in
            txt|log|sh|jpg) counts[$ext]=$((counts[$ext] + 1)) ;;
            *)              counts[other]=$((counts[other] + 1)) ;;
        esac
    done
    shopt -u nullglob
    for ext in "${!counts[@]}"; do
        echo "$ext : ${counts[$ext]}"
    done
    log_action "extension report $TARGET_DIR"
}

# Ask for a text and print files whose names contain it.
search_file() {
    local pattern f name found=0
    read -r -p "Text to search for in file names: " pattern
    shopt -s nullglob
    for f in "$TARGET_DIR"/*; do
        [ -f "$f" ] || continue
        name="${f##*/}"
        if [[ "$name" == *"$pattern"* ]]; then
            echo "$name"
            found=$((found + 1))
        fi
    done
    shopt -u nullglob
    [ "$found" -eq 0 ] && echo "No file name contains '$pattern'."
    log_action "search '$pattern' in $TARGET_DIR ($found found)"
}

# Copy every readable file into backups with a timestamped name.
backup_all() {
    local f name stamp saved=0 skipped=0
    mkdir -p "$BACKUP_DIR"
    stamp="$(date '+%Y%m%d_%H%M%S')"
    shopt -s nullglob
    for f in "$TARGET_DIR"/*; do
        [ -f "$f" ] || continue
        if [ ! -r "$f" ]; then
            log_error "Cannot read '${f##*/}' - skipped."
            skipped=$((skipped + 1))
        else
            name="${f##*/}"
            cp -- "$f" "$BACKUP_DIR/${name}_${stamp}.bak"
            saved=$((saved + 1))
        fi
    done
    shopt -u nullglob
    echo "Saved: $saved Skipped: $skipped"
    log_action "backup $TARGET_DIR (saved=$saved, skipped=$skipped)"
}

# List saved backups or print a message if there are none.
list_backups() {
    local b count=0
    shopt -s nullglob
    for b in "$BACKUP_DIR"/*.bak; do
        echo "${b##*/}"
        count=$((count + 1))
    done
    shopt -u nullglob
    [ "$count" -eq 0 ] && echo "(no backups yet)"
    log_action "list backups (count=$count)"
}

# Restore a chosen backup as restored_NAME without overwriting anything.
restore_backup() {
    local name src orig dest
    read -r -p "Backup name to restore: " name
    name="${name##*/}"
    src="$BACKUP_DIR/$name"
    if [ -z "$name" ] || [ ! -f "$src" ]; then
        log_error "Backup '$name' does not exist."
        log_action "restore failed: '$name' not found"
        return 1
    fi
    orig="${name%_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9].bak}"
    dest="$TARGET_DIR/restored_$orig"
    if [ -e "$dest" ]; then
        log_error "'restored_$orig' already exists - not overwritten."
        log_action "restore failed: restored_$orig exists"
        return 1
    fi
    cp -- "$src" "$dest"
    echo "Restored to: $dest"
    log_action "restore $name -> restored_$orig"
}

# Show the interactive menu until the user chooses Exit.
show_menu() {
    local choice
    while true; do
        echo
        echo "===== File Auditor & Backup Tool ====="
        echo "Directory: $TARGET_DIR"
        echo "1) Scan directory"
        echo "2) Permission audit"
        echo "3) Extension report"
        echo "4) Search file"
        echo "5) Backup all"
        echo "6) List backups"
        echo "7) Restore backup"
        echo "0) Exit"
        read -r -p "Choice: " choice || break
        case "$choice" in
            1) scan_directory ;;
            2) permission_audit ;;
            3) extension_report ;;
            4) search_file ;;
            5) backup_all ;;
            6) list_backups ;;
            7) restore_backup ;;
            0) echo "Bye."; break ;;
            *) log_error "Invalid choice: '$choice'" ;;
        esac
    done
}

require_dir "$TARGET_DIR"

if [ -z "$ACTION" ]; then
    show_menu
else
    case "$ACTION" in
        scan)   scan_directory ;;
        perms)  permission_audit ;;
        ext)    extension_report ;;
        backup) backup_all ;;
        *)      log_error "Unknown action '$ACTION' (use: scan | perms | ext | backup)"
                exit 1 ;;
    esac
fi
