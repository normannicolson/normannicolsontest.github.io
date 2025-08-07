# Restful Azure Http Trigger Function

Sep 2017

> Code sample creating a restful azure function app with crud operations (web api style)

```
namespace Audit.WebApi.Function
{
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using Microsoft.Azure.WebJobs;
    using Microsoft.Azure.WebJobs.Extensions.Http;
    using Microsoft.Azure.WebJobs.Host;

    public static class AuditFunction
    {
        public static List<Audit> List = new List<Audit>();

        [FunctionName("GetAll")]
        public static async Task<HttpResponseMessage> GetAll([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "audits")]HttpRequestMessage req, TraceWriter log)
        {
            var response = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ObjectContent<List<Audit>>(List, new System.Net.Http.Formatting.JsonMediaTypeFormatter())
            };

            return await Task.FromResult(response);
        }

        [FunctionName("PostItem")]
        public static async Task<HttpResponseMessage> PostItem([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "audits")]HttpRequestMessage req, TraceWriter log)
        {
            var audit = await req.Content.ReadAsAsync<Audit>();

            var response = new HttpResponseMessage(HttpStatusCode.Created)
            {
                Content = new ObjectContent<Audit>(audit, new System.Net.Http.Formatting.JsonMediaTypeFormatter())
            };

            List.Add(audit);

            return response;
        }

        [FunctionName("GetItem")]
        public static async Task<HttpResponseMessage> GetItem([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "audits/{id}")]HttpRequestMessage req, string id, TraceWriter log)
        {
            var audit = new Audit
            {
                Resource = id
            };

            var response = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ObjectContent<Audit>(audit, new System.Net.Http.Formatting.JsonMediaTypeFormatter())
            };

            return await Task.FromResult(response);
        }

        [FunctionName("PutItem")]
        public static async Task<HttpResponseMessage> PutItem([HttpTrigger(AuthorizationLevel.Anonymous, "Put", Route = "audits/{id}")]HttpRequestMessage req, string id, TraceWriter log)
        {
            var audit = await req.Content.ReadAsAsync<Audit>();

            var response = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ObjectContent<Audit>(audit, new System.Net.Http.Formatting.JsonMediaTypeFormatter())
            };

            return await Task.FromResult(response);
        }

        [FunctionName("DeleteItem")]
        public static async Task<HttpResponseMessage> DeleteItem([HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "audits/{id}")]HttpRequestMessage req, string id, TraceWriter log)
        {
            var audit = new Audit();

            var response = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ObjectContent<Audit>(audit, new System.Net.Http.Formatting.JsonMediaTypeFormatter())
            };

            return await Task.FromResult(response);
        }
    }
}
```