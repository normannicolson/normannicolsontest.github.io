# HttpClient

Oct 2017

> With microservices providing architecture flexibility httpclient makes it easy to interact with remote systems

```
namespace Nlist.Client 
{
    using System;
    using System.Net.Http.Headers;

    public interface IHttpClientWrapper
    {
        IHttpClientWrapper AddHeader(MediaTypeWithQualityHeaderValue acceptHeader);

        IHttpClientWrapper AddHeader(string name, string value);

        Task<System.Net.Http.HttpResponseMessage> GetAsync(string requestUri);

        Task<System.Net.Http.HttpResponseMessage> PutAsync(string requestUri, System.Net.Http.HttpContent content);

        Task<System.Net.Http.HttpResponseMessage> PostAsync(string requestUri, System.Net.Http.HttpContent content);

        Task<System.Net.Http.HttpResponseMessage> DeleteAsync(string requestUri);
    }
}
```

```
namespace Nlist.Client
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;

    public class HttpClientWrapper : IHttpClientWrapper
    {
        private readonly HttpClient httpClient;

        public HttpClientWrapper(HttpClient httpClient)
        {
            this.httpClient = httpClient;
        }

        public HttpClientWrapper()
        {
            this.httpClient = new HttpClient();
        }

        public IHttpClientWrapper AddHeader(MediaTypeWithQualityHeaderValue acceptHeader)
        {
            this.httpClient.DefaultRequestHeaders.Accept.Add(acceptHeader);
            return this;
        }

        public IHttpClientWrapper AddHeader(string name, string value)
        {
            IEnumerable<string> exists;
            
            this.httpClient.DefaultRequestHeaders.TryGetValues(name, out exists);

            if (exists == null)
            {
                this.httpClient.DefaultRequestHeaders.Add(name, value);
            }

            return this;
        }

        public async Task<HttpResponseMessage> GetAsync(string requestUri)
        {
            return await this.httpClient.GetAsync(requestUri);
        }

        public async Task<HttpResponseMessage> PostAsync(string requestUri, HttpContent content)
        {
            return await this.httpClient.PostAsync(requestUri, content);
        }

        public async Task<HttpResponseMessage> PutAsync(string requestUri, HttpContent content)
        {
            return await this.httpClient.PutAsync(requestUri, content);
        }

        public async Task<HttpResponseMessage> DeleteAsync(string requestUri)
        {
            return await this.httpClient.DeleteAsync(requestUri);
        }
    }
}
```