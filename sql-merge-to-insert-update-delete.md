# Sql Merge to Insert Update Delete

Nov 2019

> Merge statement to insert update delete

```
SET XACT_ABORT ON
BEGIN TRANSACTION  

	CREATE TABLE Nodes (
		Id INT
		,ParentId INT
		,Name NVARCHAR(128)    
	);

	INSERT INTO Nodes
	VALUES (1,Null,'Home');

	INSERT INTO Nodes
	VALUES (2,Null,'Services');

	MERGE INTO Nodes Target
	USING (VALUES
		 (1,Null,'Home Updated')
		,(3,1,'Architecture')
	) AS Source ([Id],[ParentId],[Name])
	ON (Target.[Id] = Source.[Id])
	WHEN MATCHED THEN 
		UPDATE SET 
		Target.[ParentId] = Source.[ParentId],
		Target.[Name] = Source.[Name]
	WHEN NOT MATCHED BY TARGET THEN
		INSERT([Id],[ParentId],[Name])
		VALUES (Source.[Id],Source.[ParentId],Source.[Name])
	WHEN NOT MATCHED BY SOURCE THEN 
		DELETE;

	SELECT *
	FROM Nodes

	DROP TABLE Nodes
	 
ROLLBACK TRANSACTION
```