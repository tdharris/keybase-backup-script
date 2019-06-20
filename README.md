# keybase-backup-script
Simple backup script for Linux intended for backing up local files to Keybase FileSystem (KBFS).

### Pre-requisites
- Install [Keybase](https://keybase.io/docs/the_app/install_linux)

### Install
- Download `backup.sh`
- Create a backup files list with each file on a new line (i.e. `files.txt`)
- Configure variables in script appropriately:
```
# Config
# Keybase
kb_mount="/keybase"
kb_user="keybase-user-id"
kb_stop_after=TRUE

# backup location
backup_path="$kb_mount/private/$kb_user/path/to/backup"
backup_list="/path/to/files.txt"
backup_list_context="/"
```
- Run backup to test with small file list: `./backup.sh`
- Setup with crontab to perform automated backup routine
