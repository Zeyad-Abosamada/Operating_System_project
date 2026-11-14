====================================================================
Project: File Auditor & Backup Tool
Course: Operating Systems
University: Alexandria National University
====================================================================

1. Team Members & Work Distribution
--------------------------------------------------------------------
- [ Name : Zeyad medhat amssoud ] ( id : 24026018 )
- [ Name : Hossam hassan abdellatif ] ( id : 2406015 )
  * Responsibilities: WE Designed and implemented together lib.sh (logging and validation helpers) and auditor.sh (all 7 features, command-line parsing, and the interactive menu).

2. Project Description
--------------------------------------------------------------------
A menu-driven Bash script that audits a target directory, reports file 
permissions, counts files by extension, searches for files, and provides 
a backup/restore system without ever overwriting original files.

3. Files Included
--------------------------------------------------------------------
- auditor.sh : The main script containing the menu, command-line handling, and feature functions.
- lib.sh     : Helper functions (log_info, log_error, log_action, require_dir).
- README.txt : This file.

4. How to Run
--------------------------------------------------------------------
1. Open the terminal and navigate to the project folder.
2. Make the scripts executable (if not already):
   chmod +x auditor.sh lib.sh
3. Run the interactive menu:
   ./auditor.sh <directory>
   Example: ./auditor.sh ./sample_data

4. Run a specific action directly from the command line:
   ./auditor.sh <directory> <action>
   Available actions: scan | perms | ext | backup
   
   Examples:
   ./auditor.sh ./sample_data scan
   ./auditor.sh ./sample_data perms
   ./auditor.sh ./sample_data ext
   ./auditor.sh ./sample_data backup

5. Implemented Features
--------------------------------------------------------------------
- Scan: Lists files and directories with counts.
- Permission Audit: Shows r/w/x flags and counts unreadable/executable files.
- Extension Report: Counts files per extension (txt, log, sh, jpg, other) using an associative array.
- Search: Finds files by text in their names.
- Backup: Copies readable files to a "backups" folder with a timestamp.
- List Backups: Lists saved backup files.
- Restore: Restores a backup safely as "restored_NAME" without overwriting.
- Logging: All actions are logged to "auditor.log" with a timestamp.

Note: The "backups" folder and "auditor.log" file are generated at runtime 
and are not included in this submission, as per project instructions.
====================================================================
