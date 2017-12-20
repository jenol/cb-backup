# Agoda Homes Couchbase Backup #

This script is using **[cbtransfer.exe](https://developer.couchbase.com/documentation/server/current/cli/cbtransfer-tool.html)** which is installed on machines with Couchbase.

## cbtransfer and backup.cmd ##

The command details are in backup.cmd. You need to change this file to if Coucbase is installed on another drive than **D:** This script will call **[cbtransfer.exe](https://developer.couchbase.com/documentation/server/current/cli/cbtransfer-tool.html)** and will only back up keys starting with **NHA_**

## backup.ps1 and sqlite ##

**backup.ps1** calls the backup.cmd and then it extracts the backup data into .csv files using sqlite. The couchbase backup files are **[sqlite](https://www.sqlite.org/)** compatible and will be called **data-0000.cbb**

You will need to modify the .ps1 file to set the *backupPath* and *server* variables

    $server = "10.120.2.23" #your server
    $backupPath = "C:\Users\jlaszlo\Desktop\a" #your backup path

If you want to backup to a share you need to map it as a drive on Windows 

## Folder structure  ##

When you run the script the first time it will create a full backup. Every new run create a diff backup. The full and diff backups will be under your backup folder and the generated day folder. 

    [backup folder]
    └───[day folder]
        ├───[run datetime]-full
        │   └───bucket-[bucket name]
        │       └───node-[node name]
        └───[run datetime]-diff
            └───bucket-[bucket name]
                └───node-[node name]

Example

    C:\USERS\JLASZLO\DESKTOP\A
    └───2017-08-04T072812Z
        ├───2017-08-04T072812Z-full
        │   └───bucket-ycs
        │       └───node-bk-qalmc-1002.agoda.local%3A8091
        └───2017-08-04T072841Z-diff
            └───bucket-ycs
                └───node-bk-qalmc-1002.agoda.local%3A8091

## Backup files ##

Under bucket-[bucket name] you fill find the following files

- data-0000.cbb - **[sqlite](https://www.sqlite.org/)** backup
- cbb_meta.csv - the meta table as CSV from the **[sqlite](https://www.sqlite.org/)** database
- cbb_msg.csv - the document table as CSV from the sqlite database. This will have the json, expiration, etc