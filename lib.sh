#!/bin/bash
# Helper functions for the File Auditor & Backup Tool.

# Print an info message.
log_info() {
    echo "[INFO] $*"
}

# Print an error message to stderr.
log_error() {
    echo "[ERROR] $*" >&2
}

# Append one action line with date and time to the log file.
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "${LOG_FILE:-auditor.log}"
}

# Stop with an error if the given path is not a directory.
require_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        log_error "Directory '$dir' does not exist."
        exit 1
    fi
}
