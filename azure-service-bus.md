# Azure Service Bus

Jan 2018

> Azure service bus can buffer application spikes useful for microservice architecture async event collaboration.

```
namespace Nlist.Concept.AzureServcieBus
{
    using System.Net;
    using System.Net.Http;
    using System.Text;
    using System.Threading.Tasks;
    using Microsoft.Azure.ServiceBus;
    using Nlist.Concept.AzureServcieBus.Wrappers;

    public class TopicSendClientWrapper
    {
        private ITopicClient topicClient;
        private IJsonConvertWrapper jsonConvertWrapper;
        private IEncodingWrapper encodingWrapper;

        public TopicSendClientWrapper(
            ITopicClient topicClient,
            IJsonConvertWrapper jsonConvertWrapper,
            IEncodingWrapper encodingWrapper)
        {
            this.topicClient = topicClient;
            this.jsonConvertWrapper = jsonConvertWrapper;
            this.encodingWrapper = encodingWrapper;
        }

        public async Task SendAsync<T>(T model)
        {
            string messageBody = this.jsonConvertWrapper.SerializeObject(model);

            var message = new Message(this.encodingWrapper.GetBytes(messageBody));

            var properties = typeof(T).GetProperties();

            foreach (var property in properties)
            {
                if (property.PropertyType == typeof(string))
                {
                    message.UserProperties.Add(
                        property.Name, 
                        property.GetValue(model).ToString());
                }
            }

            await this.topicClient.SendAsync(message);
        }
    }
}
```

Receive 

```
namespace Nlist.Concept.AzureServcieBus
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Http;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Azure.ServiceBus;
    using Nlist.Concept.AzureServcieBus.Wrappers;

    public class TopicReceiveClientWrapper
    {
        private ISubscriptionClient subscriptionClient;
        private IJsonConvertWrapper jsonConvertWrapper;
        private IEncodingWrapper encodingWrapper;
        private IList<Nlist.Concept.AzureServcieBus.Models.Message> receivedMessages;
        private Action<Message> processMessageHandler;

        public TopicReceiveClientWrapper(
            ISubscriptionClient subscriptionClient,
            IJsonConvertWrapper jsonConvertWrapper,
            IEncodingWrapper encodingWrapper,
            IList<Nlist.Concept.AzureServcieBus.Models.Message> receivedMessages,
            Action<Message> processMessageHandler)
        {
            this.subscriptionClient = subscriptionClient;
            this.jsonConvertWrapper = jsonConvertWrapper;
            this.encodingWrapper = encodingWrapper;
            this.receivedMessages = receivedMessages;

            var messageHandlerOptions = new MessageHandlerOptions(ExceptionReceivedHandler)
            {
                MaxConcurrentCalls = 1,
                AutoComplete = false
            };
            
            subscriptionClient.RegisterMessageHandler(ProcessMessagesAsync, messageHandlerOptions);
        }

        private async Task ProcessMessagesAsync(Message message, CancellationToken token)
        {
            var modelString = this.encodingWrapper.GetString(message.Body);
            var model = this.jsonConvertWrapper.DeserializeObject<Nlist.Concept.AzureServcieBus.Models.Message>(modelString);

            this.receivedMessages.Add(model);
            
            await subscriptionClient.CompleteAsync(message.SystemProperties.LockToken);

            this.processMessageHandler(message);
        }

        private Task ExceptionReceivedHandler(ExceptionReceivedEventArgs exceptionReceivedEventArgs)
        {
            var context = exceptionReceivedEventArgs.ExceptionReceivedContext;

            return Task.CompletedTask;
        }
    }
}
```