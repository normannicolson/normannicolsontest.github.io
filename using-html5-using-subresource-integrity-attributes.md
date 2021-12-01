# Using Html5 Subresource Integrity Attributes

Jan 2018

> Learn how to use subresource integrity attributes and how to generate.

Script file

```
alert("Hello");
```

Generate hash

```
openssl dgst -sha256 -binary script.js | openssl base64 -A
```

Hash

```
dEw5ICxbzlNhltZ9i6iwop7945EMiRE7yLYSnQnfnI8
```

Html 

```
<script src="script.js" integrity="sha256-dEw5ICxbzlNhltZ9i6iwop7945EMiRE7yLYSnQnfnI8"></script>
```

Set Response Headers

```
public class CspMiddleware  
{
    private readonly RequestDelegate next;

    public CspMiddleware(RequestDelegate next)
    {
        this.next = next;
    }

    public async Task Invoke(HttpContext context)
    {
        var headers = context.Response.Headers;

        headers.Add("Content-Security-Policy", "default-src 'none'");

        await this.next(context);
    }
}
```