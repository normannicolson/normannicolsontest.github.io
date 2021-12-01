# Web Api Exception Filter Attribute

Nov 2017

> Aspect orientated approach for handling controller exceptions.

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Net.Http;
using System.Web.Http.Filters;
using Nlist.Web.Api.Exceptions;

namespace Nlist.Web.Api.Filters
{
    public class ExceptionFilter : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext context)
        {
            if (context.Exception is NotFoundException)
            {
                var httpError = new System.Web.Http.HttpError("Not found");

                context.Response = context.Request
                    .CreateErrorResponse(HttpStatusCode.NotFound, httpError);
            }
            else if (context.Exception is IdException)
            {
                var httpError = new System.Web.Http.HttpError("Id must be null");

                context.Response = context.Request
                    .CreateErrorResponse(HttpStatusCode.BadRequest, httpError);
            }
            else if (context.Exception is IdNullException)
            {
                var httpError = new System.Web.Http.HttpError("Id cannot be null");

                context.Response = context.Request
                    .CreateErrorResponse(HttpStatusCode.BadRequest, httpError);
            }
            else 
            {
                var httpError = new System.Web.Http.HttpError("Internal server error");

                context.Response = context.Request
                    .CreateErrorResponse(HttpStatusCode.InternalServerError, httpError);
            }
        }
    }
}
```