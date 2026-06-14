---
title: "X-Frame-Options"
nav_order: 8
parent: "Configuration"
---

# Configuring X-Frame-Options

This header can be configured in three ways:

| Configuration       | Resulting header            |
|---------------------|-----------------------------|
| policy="Disabled"   | None                        |
| policy="Deny"       | X-Frame-Options: Deny       |
| policy="SameOrigin" | X-Frame-Options: SameOrigin |

Register the middleware in the startup class:

```csharp
public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
{
    ...

    app.UseStaticFiles();

    app.UseXfo(options => options.SameOrigin());

    app.UseMvc(...);
}
```

As an MVC attribute, defaults to policy="Deny":

```csharp
[XFrameOptions]
[XFrameOptions(Policy = XFrameOptionsPolicy.SameOrigin)]
```

The header is omitted for redirects.
