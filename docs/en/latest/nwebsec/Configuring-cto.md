---
title: "X-Content-Type-Options"
nav_order: 10
parent: "Configuration"
---

# Configuring X-Content-Type-Options

There are two settings:

| Configuration   | Resulting header                |
|-----------------|---------------------------------|
| enabled="false" | None                            |
| enabled="true"  | X-Content-Type-Options: nosniff |

Register the middleware in the OWIN startup class:

```csharp
public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
{
    ...

    app.UseStaticFiles();

    app.UseXContentTypeOptions();

    app.UseMvc(...);
}
```

Or as an MVC attribute (which defaults to true):

```csharp
[XContentTypeOptions]
[XContentTypeOptions(Enabled = false)]
```

The header is omitted for redirects.
