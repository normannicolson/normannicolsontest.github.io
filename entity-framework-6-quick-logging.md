# Entity Framework 6 Quick Logging

Mar 2018

> Log to file entity framework queries to easily assess if queries are optimised.

```
using (var file = new System.IO.StreamWriter("c:\\projects\\log.txt"))
{
    using (var context = new DbContext(configurationString))
    {
        context.Database.Log = s => file.WriteLine(s);

        var items = context.Items.Where(i => i.Id == 1).ToList();
    }
}
```