# Using sqlcmd to Backup & Restore Sql Database

Aug 2020

> Using sqlcmd to backup, copy and restore sql databases

Using sqlcmd to backup, copy and restore sql server databases locally.

```
& sqlcmd -S Server -Q "BACKUP DATABASE [Database] TO DISK = N'C:\Path\Database.bak' WITH NOFORMAT, NOINIT, NAME = 'Database', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
```

```
& sqlcmd -S Server -Q "RESTORE DATABASE [Database] FROM DISK = N'C:\Path\Database.bak' WITH MOVE 'Database' TO 'C:\Path\Database.mdf', MOVE Database_log' TO 'C:\Path\Database_log.mdf'"
```