C# Unit Testing Helpers Classes

Oct 2017

> Helper class to compare object graph removing comparing duplication in unit tests.

```
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nlist.Data.Sql.Fixture.Assets
{
    public abstract class BaseAssert<T> : IAssert<T>
    {
        public abstract void AreEqual(T expected, T actual);

        public void AreEqual(IEnumerable<T> expected, IEnumerable<T> actual)
        {
            AreEqual(expected.ToArray(), actual.ToArray());
        }

        public void AreEqual(T[] expected, T[] actual)
        {
            Assert.AreEqual(expected.Length, actual.Length);

            for (var i = 0; i < expected.Length; i++)
            {
                AreEqual(expected[i], actual[i]);
            }
        }
    }
}
```

```
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DataModel = Nlist.Data.Sql.Assets.Models.Asset;

namespace Nlist.Data.Sql.Fixture.Assets.Models
{
    public class AssetAssert : BaseAssert<DataModel>
    {
        public override void AreEqual(DataModel expected, DataModel actual)
        {
            Assert.AreEqual(expected.Id, actual.Id);
            Assert.AreEqual(expected.AssetTypeId, actual.AssetTypeId);
            Assert.AreEqual(expected.Created, actual.Created);
            Assert.AreEqual(expected.Name, actual.Name);
        }
    }
}
this.assetAssert.AreEqual(expected, result);
```