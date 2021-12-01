# Reflection how to turn a Class into a String Dictionary

Jun 2017

> Foundational reflection example how to interrogate a class and populate into string dictionary.

```
public interface IDictionaryHelper
{
    IDictionary<string, string> ToDictionary(string key, object obj);
}

public class DictionaryHelper : IDictionaryHelper
{
    public IDictionary<string, string> ToDictionary(string key, object obj)
    {
        var dictionary = new Dictionary<string, string>();

        if (obj != null)
        {
            var type = obj.GetType();

            if (this.IsString(type))
            {
                dictionary.Add(key, obj.ToString());
                return dictionary;
            }
            else if (this.IsValueType(type))
            {
                dictionary.Add(key, obj.ToString());
                return dictionary;
            }
            else if (this.IsEnumerable(type))
            {
                var list = ((IEnumerable<object>)obj).ToArray();

                for (var i = 0; i < list.Count(); i++)
                {
                    var name = string.Format("{0}[{1}]", key, i);

                    foreach (var item in this.ToDictionary(name, list[i]))
                    {
                        dictionary.Add(item.Key, item.Value);
                    }
                }

                return dictionary;
            }
            else
            {
                var properties = System.ComponentModel.TypeDescriptor.GetProperties(obj);

                foreach (System.ComponentModel.PropertyDescriptor property in properties)
                {
                    var propertyInfo = type.GetProperty(property.Name);

                    var overridable = this.IsOverridable(propertyInfo);

                    if (!overridable)
                    {
                        var subObject = property.GetValue(obj);

                        var name = key == string.Empty
                            ? property.Name
                            : key + "." + property.Name;

                        foreach (var item in this.ToDictionary(name, subObject))
                        {
                            dictionary.Add(item.Key, item.Value);
                        }
                    }
                }

                return dictionary;
            }
        }
        else
        {
            dictionary.Add(key, string.Empty);
            return dictionary;
        }
    }

    private bool IsString(Type type)
    {
        return type == typeof(string);
    }

    private bool IsValueType(Type type)
    {
        return type.IsValueType;
    }

    private bool IsEnumerable(Type type)
    {
        return typeof(IEnumerable).IsAssignableFrom(type);
    }

    private bool IsOverridable(System.Reflection.PropertyInfo propertyInfo)
    {
        return propertyInfo.GetMethod.IsVirtual && !propertyInfo.GetMethod.IsFinal;
    }
}

public void GivenComplexObjectWhenCreateCalledThenDictionaryReturned()
{
    var dictionaryHelper = new DictionaryHelper();

    var obj = new CompositeClass()
    {
        StringProperty = "StringProperty",
        IntProperty = 1,
        BoolProperty = false,
        ListProperty = new[] { "Value" },
        ClassProperty = new ExampleClass()
        {
            Property1 = "ClassPropertyProperty1"
        },
        EnumProperty = ExampleEnum.Enum1
    };

    var expected = new Dictionary<string, string>
            {
                { "StringProperty", "StringProperty" },
                { "IntProperty", "1" },
                { "BoolProperty", "False" },
                { "ListProperty[0]", "Value" },
                { "ClassProperty.Property1", "ClassPropertyProperty1" },
                { "EnumProperty", "Enum1" }
            };

    var values = dictionaryHelper.ToDictionary(string.Empty, obj);

    Assert.AreEqual(expected, values);
}
```