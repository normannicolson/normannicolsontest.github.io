# Continuous Delivery Data Population Strategies

Mar 2019

> Strategies for achieving data continuous delivery.

Continuous delivery is the practice automatically publishing committed code out to production within an automated pipeline, an automated pipeline validates via unit, integration, service, automated, load & security tests.

Within data driven applications achieving continuous delivery in data storage becomes a key element in achieving agility. Data is different from code in that it changes through usage.

First step to achieve data continuous delivery is source controlling data storage, achieving repeatable rollout and rollback, this can be achieved by source controlling every change to database, avoid modifying database if Sql directly in Sql management studio.

## Schema 

Rolling back a database schema is more complex than rolling back a codebase (to rollback a codebase you publish out the historic version), to rollback a database you need to maintain data integrity, map data between columns rolling forward and back migrating data between columns, typically rollback is not performed.

Rollout and rollback can be achieved using visual studio database project (but has its gotchas as will drop columns and lose data not what you want), Entity Framework code first migrations compare previous migration to current code first migration and creates new migration to rollout and rollback, rollout and rollback information is stored in database.

This technique database maintains rollout and rollback information within database, this information will be used to rollback. For example database version 8 was published but an error occurred and version 7 was published to roll back, version 7 has no knowledge of how to rollback database version 8, database contains this information and is used to rollback.     

My preferred approach is version every database change craft rollout and rollback sql statements. Every database change has rollout and rollback script using create, update and drop statements, these statements are responsible for schema and any data migrations for example moving data to a new column and vice versus for rollback.

Keeping data population separate keeps codebase clean and easy to understand and navigate.

```
CREATE TABLE AssetType
(
	Id INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(64) NOT NULL,
	Description NVARCHAR(256)
)
```

```
ALTER TABLE AssetType
ADD NewColumn NVARCHAR(128)

ALTER TABLE AssetType
DROP COLUMN NewColumn
```

## Application Master Data

Once a schema deployed master data or static data requires to be populated typically this data is required for the application to work, example Asset Type information. Merge scripts are a great option as avoids requirement for rollout and rollback. Insert, Update & Delete are contained in one statement.  

```
SET IDENTITY_INSERT [AssetType] ON

MERGE INTO [AssetType] AS Target
USING (VALUES
	(1,'Asset1',''),
	(2,'Asset2',''),
	(3,'Asset3','')
) AS Source ([Id],[Name],[Description])
ON (Target.[Id] = Source.[Id])
WHEN MATCHED THEN 
	UPDATE SET
	[Name] = Source.[Name],
	[Description] = Source.[Description]
WHEN NOT MATCHED BY TARGET THEN
	 INSERT([Id],[Name],[Description])
	 VALUES(Source.[Id],Source.[Name],Source.[Description]);

SET IDENTITY_INSERT [AssetType] OFF
```

Once application master data populated the application is ready to use with all required reference data, every application install will contain this data.

## Environment Master Data Population  

Environment data or initial load load is customer specific data like branding, locations, contacts etc, and same merge approach can be used to populate.

```
SET IDENTITY_INSERT [AssetType] ON

MERGE INTO [AssetType] AS Target
USING (VALUES
	(1,'Asset1',''),
	(2,'Asset2',''),
	(3,'Asset3','')
) AS Source ([Id],[Name],[Description])
ON (Target.[Id] = Source.[Id])
WHEN MATCHED THEN 
	UPDATE SET
	[Name] = Source.[Name],
	[Description] = Source.[Description]
WHEN NOT MATCHED BY TARGET THEN
	 INSERT([Id],[Name],[Description])
	 VALUES(Source.[Id],Source.[Name],Source.[Description]);

SET IDENTITY_INSERT [AssetType] OFF
```

## Transactional Data

Transactional data is populated by application usage, for test environments on demand source controlled DELETE and INSERT statements could be used to populate test environment into known state for repeatable automation tests.

## Summary

- Create update schema 
- Populate with Application master data
- Populate with Environment/Customer master data

With no sql you need to maintain version of schema in code, including version in storage enabling migration of data on demand. 