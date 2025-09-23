# Entity Framework Entity Configuration 

Jul 2025

> Using EntityTypeConfiguration classes

```
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Nlist.Entity.Models;

namespace Nlist.Entity.Configurations;

public class CustomerConfiguration : IEntityTypeConfiguration<Customer>
{
    public void Configure(EntityTypeBuilder<Post> builder)
    {
        // Table name
        builder.ToTable("Posts");

        // Primary key
        builder.HasKey(e => e.ObjectId);

        // Properties
        builder.Property(e => e.ObjectId)
            .IsRequired();

        builder.Property(e => e.Name)
            .IsRequired()
            .HasMaxLength(512);

        builder.Property(e => e.Created)
            .IsRequired()
            .HasDefaultValueSql("GETUTCDATE()");

        builder.Property(e => e.CreatedBy)
            .IsRequired();

        builder.Property(e => e.Updated)
            .IsRequired()
            .HasDefaultValueSql("GETUTCDATE()");

        builder.Property(e => e.UpdatedBy)
            .IsRequired();

        // Indexes
        builder.HasIndex(e => e.Name)
            .HasDatabaseName("IX_Post_Name");
    }
}
```