# Expression Trees Domain Layer to Data Layer Queries *

Sep 2017

> Convert business layer predicate expressions to data layer expressions.

Expression trees are great way to offer flexible queries while maintaining separation of business logic from data logic.

A Repository is responsible for saving and querying data, it implements the domain model interface, the business layer is only programmed against the domain model interface meaning data storage is completely abstracted data can be stored in Sql, No Sql or another storage.

This can lead to a very chatty interface if there are many datastore lookups.

https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/expression-trees/index

Repository:

```
public override IList<Account> Find(Expression<Func<Account, bool>> predicate)
{
    return base.Find(predicate);
}
```

Base:

```
public override IList<TEntity> Find(Expression<Func<TEntity, bool>> predicate)
{
    return this.GetItems().Where(predicate.Compile()).ToList();
}
```