# Sql Recursive Joins using With and Union All

Nov 2019

> Select all within hierarchy from self referencing table

Table

```
| Id  | ParentId | Name                   |
| 1   | Null     | Home                   |
| 2   | 1        | Services               |
| 3   | 2        | Architecture           |
| 4   | 2        | Scrum                  |
| 5   | 2        | Impact Mapping         |
| 6   | 1        | Technology             |
| 7   | 6        | Platform               |
| 8   | 6        | Languages & frameworks |
| 9   | 6        | Tools                  |
| 10  | 6        | Techniques             |
```

Query

```
;WITH NodesCte (
	 Id
	,ParentId
	,Name   
) AS
(
	SELECT Id, ParentId, Name
	FROM Nodes
	WHERE Id = 2
	UNION ALL

	SELECT Nodes.Id, Nodes.ParentId, Nodes.Name
	FROM Nodes
	INNER JOIN NodesCte ON NodesCte.Id = Nodes.ParentId
)
SELECT * 
FROM NodesCte
```

Result

```
| Id  | ParentId | Name                   |
| 2   | 1        | Services               |
| 3   | 2        | Architecture           |
| 4   | 2        | Scrum                  |
| 5   | 2        | Impact 
Mapping         |
```

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
	VALUES (2,1,'Services');

	INSERT INTO Nodes
	VALUES (3,2,'Architecture');

	INSERT INTO Nodes
	VALUES (4,2,'Scrum');

	INSERT INTO Nodes
	VALUES (5,2,'Impact Mapping');

	INSERT INTO Nodes
	VALUES (6,1,'Technology');

	INSERT INTO Nodes
	VALUES (7,6,'Platform');

	INSERT INTO Nodes
	VALUES (8,6,'Languages & frameworks');

	INSERT INTO Nodes
	VALUES (9,6,'Tools');

	INSERT INTO Nodes
	VALUES (10,6,'Techniques');

	SELECT *
	FROM Nodes

	;WITH NodesCte (
		Id
		,ParentId
		,Name   
	) AS
	(
		SELECT Id, ParentId, Name
		FROM Nodes
		WHERE Id = 2
		UNION ALL

		SELECT Nodes.Id, Nodes.ParentId, Nodes.Name
		FROM Nodes
		INNER JOIN NodesCte ON NodesCte.Id = Nodes.ParentId
	)
	SELECT * 
	FROM NodesCte

	DROP TABLE Nodes
	 
ROLLBACK TRANSACTION
```