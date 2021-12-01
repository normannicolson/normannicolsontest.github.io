# Sql Joins

Nov 2019

> Inner, left outer, right outer & full outer join examples

```
SET XACT_ABORT ON
BEGIN TRANSACTION  

	CREATE TABLE Post (
		 Id INT NOT NULL PRIMARY KEY(Id)
		,Html NVARCHAR(MAX) NOT NULL    
	);

	CREATE TABLE Comment (
		 Id INT NOT NULL
		,PostId INT NOT NULL FOREIGN KEY (PostId) REFERENCES Post(Id)
		,Text NVARCHAR(2048) NOT NULL
	);

	INSERT INTO Post
	VALUES (1,'Post 1');

	INSERT INTO Post
	VALUES (2,'Post 2');

	INSERT INTO Post
	VALUES (3,'Post 3');

	INSERT INTO Post
	VALUES (4,'Post 4');

	INSERT INTO Post
	VALUES (5,'Post 5');

	INSERT INTO Comment
	VALUES (1, 1, 'Post 1 Comment 1')

	INSERT INTO Comment
	VALUES (2, 1, 'Post 1 Comment 2')

	INSERT INTO Comment
	VALUES (3, 1, 'Post 1 Comment 3')

	INSERT INTO Comment
	VALUES (4, 2, 'Post 2 Comment 1')

	INSERT INTO Comment
	VALUES (5, 2, 'Post 2 Comment 2')

	INSERT INTO Comment
	VALUES (6, 3, 'Post 3 Comment 1')

	INSERT INTO Comment
	VALUES (7, 3, 'Post 3 Comment 2')

	INSERT INTO Comment
	VALUES (8, 3, 'Post 3 Comment 3')

	--INNER JOIN returns records that have matching values in both tables
	SELECT *
	FROM Post
	INNER JOIN Comment 
	ON Post.Id = Comment.PostId

	--LEFT OUTER JOIN returns all records from the left table, and the matched records from the right table
	SELECT *
	FROM Post
	LEFT OUTER JOIN Comment 
	ON Post.Id = Comment.PostId

	--RIGHT OUTER JOIN returns all records from the right table, and the matched records from the left table
	SELECT *
	FROM Post
	RIGHT OUTER JOIN Comment 
	ON Post.Id = Comment.PostId

	--FULL OUTER JOIN returns all records when there is a match in either left or right table
	SELECT *
	FROM Post
	FULL OUTER JOIN Comment 
	ON Post.Id = Comment.PostId

	DROP TABLE Comment
	DROP TABLE Post

ROLLBACK TRANSACTION
```