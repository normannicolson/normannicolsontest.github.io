# Sql Attach Database

> Sql script to attach database useful for automated testing and require a replay data environment.

```sql
CREATE DATABASE [databasename]  
ON (FILENAME = 'C:\path\path\databasename.mdf'),   
(FILENAME = 'C:\path\path\databasename_log.ldf')   
FOR ATTACH;
```
