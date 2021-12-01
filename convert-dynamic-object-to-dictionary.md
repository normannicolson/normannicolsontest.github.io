# Convert Dynamic Object to Dictionary

Mar 2018

> Code snippet that takes dynamic object and converts to string dictionary.

```
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
```