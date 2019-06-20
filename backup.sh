#!/bin/bash 

# Config
# Keybase
kb_mount="/keybase"
kb_user="keybase-user-id"
kb_stop_after=TRUE

# backup location
backup_path="$kb_mount/private/$kb_user/path/to/backup"
backup_list="/path/to/files.txt"
backup_list_context="/"

# Other
char_success="\e[32m\u2714\e[39m"
char_failure="\e[31mX\e[39m"

function backup {
  echo -e "\nBackup...\n"
  # (u) update, (r) recursive, (R) keep folder structure, (v) verbose
  rsync -urRv --no-perms --no-owner --no-group --recursive --files-from="$backup_list" "$backup_list_context" "$backup_path"
}

function pre {

  echo -e "\nVerifying...\n"

  # Process check & start
  pgrep -x keybase >/dev/null 
  if [ $? -eq 0 ]; then
    echo -e "\t$char_success Keybase is running."
  else
    echo -e "\tWarning: Keybase is offline. Attempting to start..."
    # start keybase without gui
    run_keybase -g && echo -e "\t$char_success Started successfully. Waiting 5 seconds..." || (echo -e "\t$char_failure Error: Failed to start keybase!" && exit 1)
    sleep 5
  fi

  # Mount check
  if grep -qs "$kb_mount" /proc/mounts; then
    echo -e "\t$char_success KBFS is mounted: $kb_mount"
  else echo -e "\t$char_failure Error: KBFS is not mounted! $kb_mount" && exit 1
  fi

  # Backup path check
  if [ -d "$backup_path" ]; then
    echo -e "\t$char_success Backup path exists: $backup_path"
  else
    # mkdir -p "$backupPath"
    echo -e "\t$char_failure Error: Directory $backup_path does not exist or unable to access."
    exit 1
  fi

}

function post {

  echo -e "\nFinishing...\n"

  # (conditional) Stop Keybase
  if [ $kb_stop_after == TRUE ]; then
    echo -e "\tStopping Keybase..."
    keybase ctl stop && echo -e "\t$char_success Stopped successfully." || (echo -e "\t$char_failure Error: Failed to stop keybase!" && exit 1)
  fi

  echo -e "\n$char_success Finished backup procedure.\n"

}

# Backup Procedure
pre
backup
post

