# Web Api Action Filter Attribute

Nov 2017

> Action Filter Attributes can block controller actions in a aspect orientated approach for example if unverified user or model data is invalid to ensure only valid data reaches controller.

```
namespace Nlist.Web.Api.Filters
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Web.Http.Controllers;
    using System.Web.Http.Filters;
    using System.Web.Http.ModelBinding;

    public class ValidationFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            var modelState = actionContext.ModelState;

            if (!modelState.IsValid)
            {
                actionContext.Response = actionContext.Request
                    .CreateErrorResponse(HttpStatusCode.BadRequest, modelState);
            }
        }
    }
}
```