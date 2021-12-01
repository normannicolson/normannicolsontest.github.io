# Validation Attribute

Jun 2017

> Example of asp.net mvc validation attribute that only runs if dependent property has value.

```
public class RequiredIfValidationAttribute : ValidationAttribute
{
    private readonly string propertyName;
    private readonly object desiredValue;

    public RequiredIfValidationAttribute(string propertyName, object desiredValue)
    {
        this.propertyName = propertyName;
        this.desiredValue = desiredValue;
    }

    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        var instance = validationContext.ObjectInstance;
        var type = instance.GetType();
        var propertyValue = type.GetProperty(this.propertyName).GetValue(instance, null);

        if (propertyValue != null)
        {
            if (propertyValue.ToString() == this.desiredValue.ToString())
            {
                var valueAsString = (value == null)
                    ? string.Empty
                    : value.ToString();

                if (valueAsString == string.Empty)
                {
                    return new ValidationResult(FormatErrorMessage(validationContext.DisplayName));
                }
            }
        }

        return ValidationResult.Success;
    }
}
```