# Json.Net Serialising Deserialising Interfaces

Nov 2017

> How to serialise & deserialise interface properties using Newtonsoft.

```
namespace Nlist.Concept.DocumentDb.Data.Helpers
{
    using System;
    using Newtonsoft.Json;

    public class InterfaceJsonConverter<TInterface, TImplementation> : JsonConverter 
        where TImplementation : TInterface, new()
    {
        public override bool CanConvert(Type objectType)
        {
            return typeof(TInterface) == objectType;
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            return serializer.Deserialize<TImplementation>(reader);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            serializer.Serialize(writer, value);
        }
    }
}
```

```
namespace Nlist.Concept.DocumentDb.Data.Wrappers
{
    using System.Collections.Generic;
    using Nlist.Concept.DocumentDb.Business.Models;
    using Nlist.Concept.DocumentDb.Data.Helpers;
    using Nlist.Concept.DocumentDb.Data.Models;
    using Newtonsoft.Json;

    public class SerializationWrapper : ISerializationWrapper
    {
        public SerializationWrapper()
        {
            JsonConvert.DefaultSettings = () => new JsonSerializerSettings
            {
                Converters = new List<JsonConverter>
                {
                    new InterfaceJsonConverter<IDocument<IPost>, Models.Document<IPost>>(),
                    new InterfaceJsonConverter<IPost, Models.Post>(),
                }
            };
        }

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