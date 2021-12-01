# Unit Testing Owin Middleware

Sep 2017

> Example of unit testing owin middleware.

```
namespace Company.Project.Web.Security
{
    using System.Linq;
    using System.Threading.Tasks;
    using Company.Project.Web.Security.Wrappers;
    using Microsoft.Owin;

    public class RoleMiddleware : OwinMiddleware
    {
        public RoleMiddleware(OwinMiddleware next) : base(next)
        {
        }

        public override async Task Invoke(IOwinContext context)
        {
            if (context.Authentication.User.Identity.IsAuthenticated)
            {
                var claim = context.Authentication.User.Claims.FirstOrDefault(i => i.Type == "roles");

                if (claim != null)
                {
                    var serializationWrapper = new SerializationWrapper();

                    var roles = serializationWrapper.DeserializeObject<string[]>(claim.Value);

                    var principal = new System.Security.Principal.GenericPrincipal(context.Authentication.User.Identity, roles);

                    context.Authentication.User = principal;
                    context.Request.User = principal;
                }
            }

            await Next.Invoke(context);
        }
    }
}
```

```
namespace Company.Project.Web.Security.Wrappers
{
    using System.Diagnostics.CodeAnalysis;
    using Newtonsoft.Json;

    [ExcludeFromCodeCoverage]
    public class SerializationWrapper : ISerializationWrapper
    {
        public string SerializeObject(object value)
        {
            var model = JsonConvert.SerializeObject(value);
            return model;
        }

        public T DeserializeObject<T>(string value)
        {
            var model = JsonConvert.DeserializeObject<T>(value);
            return model;
        }
    }
}
```

```
namespace Company.Project.Web.Security.Test
{
    using Company.Project.Web.Security.Test.Fixtures;
    using NUnit.Framework;

    public class WhenRoleMiddlewareIsCalled
    {
        [Test]
        public async System.Threading.Tasks.Task GivenAuthenticatedWhenMiddlewareIsCalledThenRolesSetAsync()
        {
            var context = new OwinContextFixture().AuthenicatedWithRoles();
            var last = new DummyMiddleware();

            var middleware = new RoleMiddleware(last);
            await middleware.Invoke(context);

            Assert.IsTrue(context.Authentication.User.IsInRole("Sponsor"));
        }
    }
}
```

```
namespace Company.Project.Web.Security.Test.Fixtures
{
    using System.Collections.Generic;
    using System.Security.Claims;
    using System.Security.Principal;
    using Microsoft.Owin;
    using Microsoft.Owin.Security;
    using Rhino.Mocks;
    
    public class OwinContextFixture
    {
        public IOwinContext AuthenicatedWithRoles()
        {
            var mocks = new MockRepository();

            var context = mocks.StrictMock<IOwinContext>();
            var authentication = mocks.StrictMock<IAuthenticationManager>();
            var user = mocks.StrictMock<ClaimsPrincipal>();
            var identity = mocks.StrictMock<IIdentity>();
            var claims = new List<Claim>
            {
                new Claim("roles", "[\"User\",\"Sponsor\"]")
            };
            var request = mocks.StrictMock<IOwinRequest>();

            context.Stub(i => i.Authentication)
                .Return(authentication);

            authentication.Stub(i => i.User)
                .PropertyBehavior();

            authentication.User = user;

            user.Stub(i => i.Identity)
                .Return(identity);

            user.Stub(i => i.Claims)
                .Return(claims);

            identity.Stub(i => i.IsAuthenticated)
                .Return(true);

            identity.Stub(i => i.AuthenticationType)
                .Return("Claims");

            identity.Stub(i => i.Name)
                .Return("Name");

            context.Stub(i => i.Request)
                .Return(request);

            request.Stub(i => i.User)
                .PropertyBehavior();

            request.User = user;

            mocks.ReplayAll();

            return context;
        }
    }
}
```

```
namespace Company.Project.Web.Security.Test.Fixtures
{
    using System.Threading.Tasks;
    using Microsoft.Owin;

    public class DummyMiddleware : OwinMiddleware
    {
        public DummyMiddleware() : base(null)
        {
        }

        public override async Task Invoke(IOwinContext context)
        {
            await Task.FromResult(0);
        }
    }
}
```