# Async Unit Testing

Sep 2017

> Async unit test calling async controller action code snippet.

```
namespace Company.Project.Web.Test
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Web.Mvc;
    using System.Web.Routing;
    using NUnit.Framework;
    using Rhino.Mocks;

    public class WhenUserControllerIsCalled
    {
        private UserController controller;

        [SetUp]
        public void Setup()
        {
            this.controller = new UserController()
        }

        [TearDown]
        public void TearDown()
        {
            this.controller = null;
        }

        [Test]
        public async Task GivenNoParamsWhenFindIsCalledThenFindViewReturned()
        {
            var model = new Model();

            var result = await this.controller.Find();

            var viewResult = (ViewResult)result;

            Assert.IsNotNull(viewResult);
            Assert.IsNotNull(viewResult.Model);
            Assert.AreEqual(string.Empty, viewResult.ViewName);
        }
    }
}
```