# Document Db Repository

Nov 2017

> Implementation of repository pattern against document db.

```
namespace Nlist.Concept.DocumentDb.Data.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Nlist.Concept.DocumentDb.Business.Model.Models;
    using Nlist.Concept.DocumentDb.Business.Model.Repositories;
    using Nlist.Concept.DocumentDb.Data.Wrappers;
    using Microsoft.Azure.Documents;
    using Microsoft.Azure.Documents.Client;

    public class EntityRepository<T, TId> : IEntityAddRepository<T, TId>
        where T : class, IEntity<TId>
    {
        private readonly IEntityRepositorySettings entityRepositorySettings;
        private readonly IUriFactoryWrapper uriFactoryWrapper;
        private readonly ISerializationWrapper serializationWrapper;
        private readonly IDocumentClient client;

        public EntityRepository(IEntityRepositorySettings entityRepositorySettings, IUriFactoryWrapper uriFactoryWrapper, ISerializationWrapper serializationWrapper, IDocumentClient client)
        {
            this.entityRepositorySettings = entityRepositorySettings;
            this.uriFactoryWrapper = uriFactoryWrapper;
            this.serializationWrapper = serializationWrapper;
            this.client = client;  
        }

        public async Task<T> AddAsync(T model)
        {
            var collectionUri = this.uriFactoryWrapper.CreateDocumentCollectionUri(this.entityRepositorySettings.DatabaseId, this.entityRepositorySettings.CollectionId); 

            var document = await this.client.CreateDocumentAsync(collectionUri, model);
            return this.DeserializedObject(document);
        }

        public async Task<T> UpdateAsync(T model)
        {
            var data = this.GetDocumentById(model.Id.ToString());

            var document = await this.client.ReplaceDocumentAsync(data.SelfLink, model);
            return this.DeserializedObject(document);
        }

        public async Task<T> DeleteAsync(T model)
        {
            var data = this.GetDocumentById(model.Id.ToString());

            var document = await this.client.DeleteDocumentAsync(data.SelfLink);
            return model;
        }

        public IList<T> GetItemsByIdsAsync(params TId[] ids)
        {
            var collectionUri = this.uriFactoryWrapper.CreateDocumentCollectionUri(this.entityRepositorySettings.DatabaseId, this.entityRepositorySettings.CollectionId);

            var data = this.client.CreateDocumentQuery<T>(collectionUri)
                .Where(d => ids.Contains(d.Id))
                .ToList();

            return data;
        }

        public T GetItemByIdAsync(Guid id)
        {
            var data = this.GetDocumentById(id.ToString());

            if (data != null)
            {
                return this.DeserializedObject(data);
            }

            return default(T);
        }

        public IList<T> GetItemsAsync()
        {
            var collectionUri = this.uriFactoryWrapper.CreateDocumentCollectionUri(this.entityRepositorySettings.DatabaseId, this.entityRepositorySettings.CollectionId);

            var data = this.client.CreateDocumentQuery<T>(collectionUri)
                .ToList();

            return data;
        }

        private Document GetDocumentById(string id)
        {
            var collectionUri = this.uriFactoryWrapper.CreateDocumentUri(this.entityRepositorySettings.DatabaseId, this.entityRepositorySettings.CollectionId, id);

            var data = this.client.CreateDocumentQuery(collectionUri, new FeedOptions { PartitionKey = new PartitionKey("Organisation") })
                .Where(d => d.Id == id)
                .AsEnumerable()
                .FirstOrDefault();

            return data;
        }

        private T DeserializedObject(Document document)
        {
            var model = this.serializationWrapper.DeserializeObject<T>(document.ToString());

            return model;
        }
    }
}
```