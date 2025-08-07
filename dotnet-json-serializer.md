# Using JsonSerializerOptions

Jul 2025

> Use JsonSerializerOptions to control serialisation flow

Camel case

```
using System.Text.Json;
using System.Text;

namespace SSEAirtricity.B2C.Utilities.API.Helpers;

public static class JsonCamelCaseHelper
{
    public static readonly JsonSerializerOptions Options = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        PropertyNameCaseInsensitive = true,
        WriteIndented = true
    };
    
    public static T? Deserialize<T>(string json)
    {
        return JsonSerializer.Deserialize<T>(json, Options);
    }
    
    public static string Serialize<T>(T obj)
    {
        return JsonSerializer.Serialize(obj, Options);
    }
}
```

Snake case

```
using System.Text.Json;
using System.Text;

namespace SSEAirtricity.B2C.Utilities.API.Helpers;

public static class JsonSnakeCaseHelper
{
    public static readonly JsonSerializerOptions Options = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
        PropertyNameCaseInsensitive = true,
        WriteIndented = true
    };
    
    public static T? Deserialize<T>(string json)
    {
        return JsonSerializer.Deserialize<T>(json, Options);
    }
    
    public static string Serialize<T>(T obj)
    {
        return JsonSerializer.Serialize(obj, Options);
    }
}

```