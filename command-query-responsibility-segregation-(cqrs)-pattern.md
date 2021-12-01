Command Query Responsibility Segregation (CQRS) Pattern
 
Oct 2017

> Design pattern that separates query/read from command/write models rather than having one combined read & write model.

Command Query Responsibility Segregation (CQRS) Pattern, is a design pattern that separates query/read from command/write models rather than having one combined model representing the data such as found in restful approach, it separates into at least two model representations one for reading and one for writing.

A good example would be a save operation on a website take updating a post.

Query/read context would read all required data for display on page including content, comments & etc.

Command/write context would update data model. This allows a separate read and write representation of data .

More info at https://martinfowler.com/bliki/CQRS.html