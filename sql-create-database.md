# Sql Create Database

May 2018

> Sql script to create local database useful for automated testing and require a replay data environment.

```
CREATE DATABASE [databasename]
ON ( NAME = 'Database', FILENAME = 'c:\path\path\databasename.mdf')  
LOG ON ( NAME = 'Log', FILENAME = 'c:\path\path\databasename_log.ldf');
```