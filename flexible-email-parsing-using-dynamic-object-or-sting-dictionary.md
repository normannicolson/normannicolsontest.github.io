# Flexible Email Parsing using Dynamic Object or Sting Dictionary

Mar 2018

> Azure function for template parsing using dynamic object or sting dictionary as data source.

There are many email parsing considerations and approaches, do we go all out and model using a Razor type syntax, custom parsing using refection or other, do we trust our editors to create valid templates, how long before we cancel runaway processes.

Dynamic or dictionary objects provide middle of the road solution, no need to interpret expressions just retrieve value by name and replace placeholders.

Following C# interpolated strings approach we use { curly brackets to express our bindings.

Template

```
Hello {Name} this is a very basic example.
```

Model

```
{
  "Id":1,
  "Data" : {
    "Name":"Jane Doe"
  }
}
```

Output

```
Hello Jane Doe this is a very basic example
```

Function

```
namespace Nlist.Concept.Function.Functions
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Threading.Tasks;
    using Nlist.Concept.Function.Data;
    using Nlist.Concept.Function.Models;
    using Microsoft.Azure.WebJobs.Host;

    public class EmailTemplate
    {
        private INotificationContext notificationContext;

        public EmailTemplate(INotificationContext notificationContext)
        {
            this.notificationContext = notificationContext;
        }

        public async Task<EmailTemplateResponse> Run(HttpRequestMessage req, TraceWriter log)
        {
            var request = await req.Content.ReadAsAsync<EmailTemplateRequest>();

            var notification = this.notificationContext.Notifications.SingleOrDefault(e => e.Id == request.Id);

            var template = notification.Template;

            var requestDictionary = ConvertToDictionary(request.Data);

            foreach (var keyValue in requestDictionary)
            {
                var placeholder = "{" + keyValue.Key + "}";
                template = template.Replace(placeholder, keyValue.Value);
            }

            return new EmailTemplateResponse
            {
                Content = template
            };
        }

        private static Dictionary<string, object> ConvertToDictionary(dynamic data)
        {
            var dictionary = new Dictionary<string, object>();

            foreach (var propertyDescriptor in System.ComponentModel.TypeDescriptor.GetProperties(data))
            {
                var value = propertyDescriptor.GetValue(data).ToString();
                dictionary.Add(propertyDescriptor.Name, value);
            }

            return dictionary;
        }
    }
}
```