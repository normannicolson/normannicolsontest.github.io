Azure Storage Table Repository

Sep 2017

> Implementation of repository pattern using azure table storage.

```
namespace Nlist.Form.Data.Storage
{
    using System;
    using System.Collections.Generic;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using Nlist.Form.Data.Storage.Models;
    using Nlist.Form.Business.Models;
    using Nlist.Form.Business.Repositories;

    public class EnquiryRepository : IRepository<Enquiry>
    {
        private readonly CloudTable table;

        public EnquiryRepository(string storageConnectionString)
        {
            var storageAccount = CloudStorageAccount.Parse(storageConnectionString);

            var tableClient = storageAccount.CreateCloudTableClient();

            CloudTable table = tableClient.GetTableReference(typeof(Enquiry).Name);

            table.CreateIfNotExists();

            this.table = tableClient.GetTableReference(table.Name);
        }

        public IList<Enquiry> GetItems()
        {
            var models = new List<Enquiry>();

            var query = new TableQuery<EnquiryTableEntity>().Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, typeof(Enquiry).Name));

            foreach (var data in table.ExecuteQuery(query))
            {
                var model = new Enquiry
                {
                    Id = new Guid(data.RowKey),
                    Created = data.Timestamp.UtcDateTime,
                    Email = data.Email,
                    Name = data.Name,
                    Telephone = data.Telephone,
                    Message = data.Message
                };

                models.Add(model);
            }

            return models;
        }

        public Enquiry GetById(Guid id)
        {
            var operation = TableOperation.Retrieve<EnquiryTableEntity>(typeof(Enquiry).Name, id.ToString());

            var result = this.table.Execute(operation);

            if (result.Result != null)
            {
                var data = (EnquiryTableEntity)result.Result;

                var model = new Enquiry
                {
                    Id = new Guid(data.RowKey),
                    Created = data.Timestamp.UtcDateTime,
                    Email = data.Email,
                    Name = data.Name,
                    Telephone = data.Telephone,
                    Message = data.Message
                };

                return model;
            }

            return null;
        }

        public Enquiry Save(Enquiry model)
        {
            var data = new EnquiryTableEntity
            {
                PartitionKey = typeof(Enquiry).Name,
                RowKey = model.Id.ToString(),
                Email = model.Email,
                Name = model.Name,
                Telephone = model.Telephone,
                Message = model.Message
            };

            var operation = TableOperation.InsertOrReplace(data);

            this.table.Execute(operation);

            return model;
        }

        public Enquiry Delete(Guid id)
        {
            var operation = TableOperation.Retrieve<EnquiryTableEntity>(typeof(Enquiry).Name, id.ToString());

            var result = this.table.Execute(operation);

            if (result.Result != null)
            {
                var data = (EnquiryTableEntity)result.Result;

                var deleteOperation = TableOperation.Delete(data);

                var deleteResult = this.table.Execute(operation);
            }

            if (result.Result != null)
            {
                var data = (EnquiryTableEntity)result.Result;

                var model = new Enquiry
                {
                    Id = new Guid(data.RowKey),
                    Created = data.Timestamp.UtcDateTime,
                    Email = data.Email,
                    Name = data.Name,
                    Telephone = data.Telephone,
                    Message = data.Message
                };

                return model;
            }

            return null;
        }
    }
}
```