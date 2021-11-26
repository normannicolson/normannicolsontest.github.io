# Content Security Policy

> Implementing a content security policy.

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

```
public void Configure(IApplicationBuilder app, IHostingEnvironment env)
{
    app.UseMiddleware<CspMiddleware>();
}
```

Allow any src resource from only https but any domain.
```
Content-Security-Policy: default-src https:
```

Only allow src resources from same site 
```
Content-Security-Policy: default-src https://example.com
```