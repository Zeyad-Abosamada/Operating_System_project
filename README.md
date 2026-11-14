1. Introduction
In a corporate environment, managing file permissions, auditing directory contents, and ensuring data redundancy are critical tasks for system administrators. The File Auditor & Backup Tool is a mini-project developed in Bash scripting to automate these Operating System tasks on Linux. It provides a secure and efficient way to inspect directories and protect files against accidental data loss.

2. Core Functionalities
The system is built around a modular architecture, separating the core logic (auditor.sh) from helper utilities (lib.sh). It offers the following key features:

Directory Scanning: Recursively audits the target folder to list all files and sub-directories, providing an accurate count of each.

Permission Auditing: Analyzes each regular file to determine the current user's read (r), write (w), and execute (x) permissions. It highlights security risks by counting unreadable or executable files (e.g., identifying files like secret.dat with 000 permissions).

Extension Reporting: Utilizes Bash associative arrays to group and count files by their extensions (e.g., .txt, .log, .sh), giving an overview of the folder's contents.

File Searching: Allows users to quickly find files by matching a text pattern within their names.

Secure Backup System: Copies all readable files into a dedicated backups/ folder, appending a timestamp (YYYYMMDD_HHMMSS) to each file. It safely skips unreadable files and logs an error.

Safe Restoration: Restores a selected backup to the original directory using a restored_ prefix. It guarantees that original files are never overwritten.

Activity Logging: Every action is documented in an auditor.log file with the exact date and time, ensuring a clear audit trail.

3. Technical Implementation

Language: Bash Scripting.

Interface: Features both a continuous interactive menu (handling invalid inputs gracefully) and a Command-Line Interface (CLI) for direct execution (e.g., ./auditor.sh /path scan).

Code Quality: The code follows strict best practices, including quoting variables to handle spaces in filenames, using local variables within functions to prevent scope leaks, and modularizing the code by sourcing a lib.sh file.

Error Handling: Includes robust validation to ensure the target directory exists before execution and handles file permission errors gracefully.

4. Conclusion
This project demonstrates the power and flexibility of Bash scripting in system administration. By combining file testing (-f, -d, -r), string manipulation, associative arrays, and command substitution, the tool provides a practical, secure, and automated solution for directory auditing and file backup management.
