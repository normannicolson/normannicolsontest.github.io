# Repository Unit Testing using Moq

Nov 2017

> Example of unit testing repository using moq.

```
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Practices.Unity;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Nlist.Business.Model.Bases.Repositories;
using Nlist.Business.Model.Bases.Models;
using Nlist.Data.Sql.Fixture;

namespace Nlist.Data.Sql.Test
{
    public abstract class When_AssetItemRepository_is_called<TDomainModel, TDataModel, TId>
        where TDomainModel : AssetItem<TId>
        where TDataModel : Nlist.Data.Sql.Bases.Models.Entity 
        where TId : IComparable, new()  

    {
        private Moq.Mock<IContext> context;
        private Moq.Mock<IMapper<TDomainModel, TDataModel>> mapper;
        private IAssetItemRepository<TDomainModel, TId> repository;
        private Nlist.Data.Sql.Fixture.IFixture<TDataModel> dataModelFixture;
        private Nlist.Business.Model.Fixture.IFixture<TDomainModel> domainModelFixture;
        private Nlist.Data.Sql.Fixture.IAssert<TDataModel> dataModelAssert;
        private Nlist.Business.Model.Fixture.IAssert<TDomainModel> domainModelAssert;

        [TestInitialize]
        public void Initialize()
        {
            var container = new App_Start.Container();

            this.context = container.Resolve<Moq.Mock<IContext>>();
            this.mapper = container.Resolve<Moq.Mock<IMapper<TDomainModel, TDataModel>>>();
            this.repository = container.Resolve<Nlist.Business.Model.Bases.Repositories.IAssetItemRepository<TDomainModel, TId>>();
            this.dataModelFixture = container.Resolve<Nlist.Data.Sql.Fixture.IFixture<TDataModel>>();
            this.domainModelFixture = container.Resolve<Nlist.Business.Model.Fixture.IFixture<TDomainModel>>();
            this.dataModelAssert = container.Resolve<Nlist.Data.Sql.Fixture.IAssert<TDataModel>>();
            this.domainModelAssert = container.Resolve<Nlist.Business.Model.Fixture.IAssert<TDomainModel>>();
        }

        [TestCleanup]
        public void Cleanup()
        {
            this.context = null;
            this.mapper = null;
            this.repository = null;
            this.dataModelFixture = null;
            this.domainModelFixture = null;
            this.dataModelAssert = null;
            this.domainModelAssert = null;
        }

        [TestMethod]
        public void When_GetItems_is_called_Given_data_in_context_Then_returns_domain_models()
        {
            var expected = this.domainModelFixture.List();

            var data = this.dataModelFixture.List();
            var dbSet = new MockDbSet<TDataModel>(data);

            this.context
                .Setup(i => i.Set<TDataModel>())
                .Returns(dbSet.Object);

            this.mapper
                .Setup(i => i.ToDomainModels(Moq.It.Is<IEnumerable<TDataModel>>(p => p == dbSet.Object)))
                .Returns(expected);

            var result = this.repository.GetItems();

            this.context
                .Verify(i => i.Set<TDataModel>(), Moq.Times.Once());

            this.mapper
                .Verify(i => i.ToDomainModels(Moq.It.Is<IEnumerable<TDataModel>>(p => p == dbSet.Object)), Moq.Times.Once());

            this.domainModelAssert.AreEqual(expected, result);
        }

        [TestMethod]
        public void When_GetItemByIds_is_called_Given_data_in_context_Then_returns_domain_models()
        {
            var expected = this.domainModelFixture.TourAndImageList();

            var data = this.dataModelFixture.List();
            var dbSet = new MockDbSet<TDataModel>(data);

            this.context
                .Setup(i => i.Set<TDataModel>())
                .Returns(dbSet.Object);

            this.mapper
                .Setup(i => i.ToDomainModels(Moq.It.IsAny<IEnumerable<TDataModel>>()))
                .Returns(expected);

            var result = this.repository.GetItemsByIds(
                expected.Select(i => i.Id).ToArray()
            );

            this.context
                .Verify(i => i.Set<TDataModel>(), Moq.Times.Once());

            this.mapper
                .Verify(i => i.ToDomainModels(Moq.It.IsAny<IEnumerable<TDataModel>>()), Moq.Times.Once());

            this.domainModelAssert.AreEqual(expected, result);
        }

        [TestMethod]
        public void When_GetItemsById_is_called_Given_data_in_context_Then_returns_domain_model()
        {
            var expected = this.domainModelFixture.Tour();

            var data = this.dataModelFixture.List();
            var dbSet = new MockDbSet<TDataModel>(data);

            this.context
                .Setup(i => i.Set<TDataModel>())
                .Returns(dbSet.Object);

            this.mapper
                .Setup(i => i.ToDomainModel(Moq.It.IsAny<TDataModel>()))
                .Returns(expected);

            var result = this.repository.GetItemById(expected.Id);

            this.context
                .Verify(i => i.Set<TDataModel>(), Moq.Times.Once());

            this.mapper
                .Verify(i => i.ToDomainModel(Moq.It.Is<TDataModel>(p => p == data.ToList().ToArray()[1])), Moq.Times.Once());

            this.domainModelAssert.AreEqual(expected, result);
        }

        [TestMethod]
        public void When_Create_is_called_Given_context_Then_adds_to_context()
        {
            var result = this.repository.Create();

            Assert.IsNotNull(result);
            Assert.AreEqual(typeof(TDomainModel), result.GetType());
        }

        [TestMethod]
        public void When_Save_is_called_Given_model_is_not_context_Then_added_to_context()
        {
            var expectedDataModel = this.dataModelFixture.Tour();
            var expected = this.domainModelFixture.Tour();

            var data = this.dataModelFixture.EmptyList();
            var dbSet = new MockDbSet<TDataModel>(data);

            this.context
                .Setup(i => i.Set<TDataModel>())
                .Returns(dbSet.Object);

            this.mapper
                .Setup(i => i.SetDataModelProperties(Moq.It.IsAny<TDataModel>(), Moq.It.IsAny<TDomainModel>()))
                .Returns(expectedDataModel);

            dbSet
                .Setup(i => i.Add(Moq.It.Is<TDataModel>(p => p == expectedDataModel)))
                .Returns(expectedDataModel);

            var result = this.repository.Save(expected);

            this.context
                .Verify(i => i.Set<TDataModel>(), Moq.Times.Exactly(2));

            this.mapper
                .Verify(i => i.SetDataModelProperties(Moq.It.IsAny<TDataModel>(), Moq.It.IsAny<TDomainModel>()), Moq.Times.Once());

            dbSet
                .Verify(i => i.Add(Moq.It.Is<TDataModel>(p => p == expectedDataModel)), Moq.Times.Once());

            this.domainModelAssert.AreEqual(expected, result);
        }

        [TestMethod]
        public void When_Save_is_called_Given_model_is_context_Then_added_to_context()
        {
            var expectedDataModel = this.dataModelFixture.Tour();
            var expected = this.domainModelFixture.Tour();

            var data = this.dataModelFixture.List();
            var dbSet = new MockDbSet<TDataModel>(data);

            this.context
                .Setup(i => i.Set<TDataModel>())
                .Returns(dbSet.Object);

            this.mapper
                .Setup(i => i.SetDataModelProperties(Moq.It.IsAny<TDataModel>(), Moq.It.IsAny<TDomainModel>()))
                .Returns(expectedDataModel);

            var result = this.repository.Save(expected);

            this.context
                .Verify(i => i.Set<TDataModel>(), Moq.Times.Once());

            this.mapper
                .Verify(i => i.SetDataModelProperties(Moq.It.IsAny<TDataModel>(), Moq.It.IsAny<TDomainModel>()), Moq.Times.Once());

            dbSet
                .Verify(i => i.Add(Moq.It.Is<TDataModel>(p => p == expectedDataModel)), Moq.Times.Never());

            this.domainModelAssert.AreEqual(expected, result);
        }

        [TestMethod]
        public void When_Delete_is_called_Given_model_is_context_Then_removed_from_context()
        {
            var data = this.dataModelFixture.List();
            var dbSet = new MockDbSet<TDataModel>(data);
            var expected = this.domainModelFixture.Tour();
            
            var expectedDataModel = data.ToArray()[1];

            this.context
                .Setup(i => i.Set<TDataModel>())
                .Returns(dbSet.Object);

            dbSet
                .Setup(i => i.Remove(Moq.It.Is<TDataModel>(p => p == expectedDataModel)))
                .Returns(expectedDataModel);

            this.repository.Delete(expected);

            this.context
                .Verify(i => i.Set<TDataModel>(), Moq.Times.Exactly(2));

            dbSet
                .Verify(i => i.Remove(Moq.It.Is<TDataModel>(p => p == expectedDataModel)), Moq.Times.Once());
        }
    }
}
```