# Fluent Validation

Nov 2018

> Nuget package for fluent validation create validator classes.

Fluent Validation Package allow us to separate validation from POCO data transfer logic, I typically decorate validation properties using component modal, Fluent Validation Package provide attribute reuse implementing many advanced scenarios where we would create custom validation attributes.  

```
public class PersonValidator : AbstractValidator<Person> {
  public PersonValidator() {
    RuleFor(x => x.Pets).Must(list => list.Count <= 10)
      .WithMessage("The list must contain fewer than 10 items");
  }
}
```

More info at https://fluentvalidation.net/custom-validators