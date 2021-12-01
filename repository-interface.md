# Repository Interface

Nov 2017

> Repository interface for handling crud operations using generics for entity identifier.

```
using System;
using System.Collections.Generic;
using Nlist.Business.Model.Bases.Models;

namespace Nlist.Business.Model.Bases.Repositories
{
    public interface IEntityRepository<T, in TId>
        where T : Entity<TId>
        where TId : IComparable, new()  
    {
        T GetItemById(TId id);
        T Create();
        T Save(T model);
        void Delete(T model);

        IList<T> GetItems();
        IList<T> GetItemsByIds(params TId[] ids);
    }
}
```