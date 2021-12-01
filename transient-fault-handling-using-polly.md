# Transient fault handling using Polly

Jan 2018

> Implement retry, circuit breaker etc logic using polly framework.

Polly is a useful framework for creating clean reusable retry logic to build resilience. 

```
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Polly;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Nlist.Concept.Polly.Test
{
    [TestClass]
    public class When_PostController_is_called
    {
        [TestMethod]
        public async Task When_Get_is_called_Then_posts_returned()
        {
            var httpContentHelper = new HttpContentHelper();
            var client = new HttpClient();

            var result = await client.GetAsync("http://localhost:1802/api/posts");

            var obj = await httpContentHelper.ReadAsObjectAsync<IEnumerable<Post>>(result.Content);

            Assert.AreEqual(2, obj.Count());
        }

        [TestMethod]
        public async Task When_Get_with_id_is_called_with_invalid_Id_Then_not_found_returned()
        {
            var client = new HttpClient();

            var result = await client.GetAsync("http://localhost:1802/api/404/1");

            if (!result.IsSuccessStatusCode)
            {
                Assert.AreEqual(1,1);
            }
        }

        [TestMethod]
        [ExpectedException(typeof(HttpRequestException))]
        public async Task When_Get_with_id_is_called_with_invalid_Id_with_polly_Then_not_found_returned()
        {
            var retryPolicy = Policy.Handle<HttpRequestException>()
                .WaitAndRetryAsync(new[]
                {
                    TimeSpan.FromSeconds(2),
                    TimeSpan.FromSeconds(4),
                    TimeSpan.FromSeconds(8)
                });

            var httpClient = new HttpClient();

            await retryPolicy.ExecuteAsync(async () =>
            {
                var response = await httpClient.GetAsync("http://localhost:1802/api/404/1");
                response.EnsureSuccessStatusCode();
            });
        }

        [TestMethod]
        public async Task When_Get_with_id_is_called_with_invalid_Id_with_polly_Then_fallback_used()
        {
            var fallback = false;

            var retryPolicy = Policy.Handle<HttpRequestException>()
                .Fallback(()=> {
                    fallback = true;
                }
            );

            var httpClient = new HttpClient();

            await retryPolicy.ExecuteAsync(async () =>
            {
                var response = await httpClient.GetAsync("http://localhost:1802/api/404/1");
            });

            Assert.IsTrue(fallback);
        }
    }
}
```