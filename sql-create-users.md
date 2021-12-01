# Sql Create Users

May 2018

> Sql script for creating users.

```sql
USE [Master]

CREATE LOGIN [databaseusername] 
WITH PASSWORD = 'password'

USE [databasename]

CREATE USER [databaseusername] 
FROM LOGIN [databaseusername] 

EXEC sp_addrolemember 'db_ddladmin', 'databaseusername'
EXEC sp_addrolemember 'db_datawriter', 'databaseusername'
EXEC sp_addrolemember 'db_datareader', 'databaseusername'
```
