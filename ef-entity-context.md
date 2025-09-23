# Entity Framework Entity 

Jul 2025

> Basic Entity Framework Entity 

```
public interface IAuditable
{
    public DateTime Created { get; set; }

    public string CreatedBy { get; set; }

    public DateTime Updated { get; set; }

    public string UpdatedBy { get; set; }
}
```

```
using System;
using Nlist.Entity.Interfaces;

namespace Nlist.Entity.Models;

public class Post : IAuditable 
{
    public Guid ObjectId { get; set; }

    public string Name { get; set; }

    public DateTime Created { get; set; }

    public string CreatedBy { get; set; }

    public DateTime Updated { get; set; }

    public string UpdatedBy { get; set; }

    public Customer()
    {
        Created = DateTime.UtcNow;
        Updated = DateTime.UtcNow;
    }
}

```

```
using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Nlist.Entity.Extensions;
using Nlist.Entity.Configurations;

namespace Nlist.Entity.Models;

public partial class Context : DbContext
{
    public Context()
    {
    }

    public Context(DbContextOptions<IdentityDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Post> Posts { get; set; };
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfiguration(new PostConfiguration());
    }
}
```