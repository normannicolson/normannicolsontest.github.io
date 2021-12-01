# Entry Framework Context

Nov 2017

> Entry framework dbcontext code first boilerplate context.

```
namespace Nlist.Data.Sql
{
    public class Context : DbContext, IContext 
    {
        static Context()
        {
            Database.SetInitializer<Context>(null);
        }

        public Context(string connectionString)
            : base(connectionString)
        {
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // Stop multiple cascade paths.
            modelBuilder.Conventions.Remove<OneToManyCascadeDeleteConvention>();

            // Switch off Pluralisation naming. 
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();

            // Add custom mapping.
            modelBuilder.Configurations.Add(new AssetTypeMap());
            modelBuilder.Configurations.Add(new AssetMap());
            modelBuilder.Configurations.Add(new AssetLinkMap());
            modelBuilder.Configurations.Add(new AssetRelationshipMap());
            modelBuilder.Configurations.Add(new AssetSearchTextMap());
            modelBuilder.Configurations.Add(new AssetSeoMap());
            modelBuilder.Configurations.Add(new AssetSummaryMap());
            modelBuilder.Configurations.Add(new AssetThumbnailMap());

            modelBuilder.Configurations.Add(new ImageMap());
            modelBuilder.Configurations.Add(new PageMap());

            modelBuilder.Configurations.Add(new UserEnquiryMap());
            modelBuilder.Configurations.Add(new UserSubscriptionMap());

            base.OnModelCreating(modelBuilder);
        }

        public IDbSet<AssetType> AssetTypes { get; set; }
        public IDbSet<Asset> Assets { get; set; }
        public IDbSet<AssetLink> AssetLinks { get; set; }
        public IDbSet<AssetRelationship> AssetRelationships { get; set; }
        public IDbSet<AssetSearchText> AssetSearchTexts { get; set; }
        public IDbSet<AssetSeo> AssetSeos { get; set; }
        public IDbSet<AssetSummary> AssetSummaries { get; set; }
        public IDbSet<AssetThumbnail> AssetThumbnails { get; set; }

        public IDbSet<Image> Images { get; set; }
        public IDbSet<Page> Pages { get; set; }

        public IDbSet<UserEnquiry> UserEnquiries { get; set; }
        public IDbSet<UserSubscription> UserSubscriptions { get; set; }

        public new int SaveChanges()
        {
            return base.SaveChanges();
        }

        public new IDbSet<TEntity> Set<TEntity>() where TEntity : class
        {
            return base.Set<TEntity>();
        }
    }
}
```