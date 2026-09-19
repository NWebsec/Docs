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

[NWebsec](NWebsec.html): In web.config

```xml
<x-Frame-Options policy="Disabled"/>
```

[NWebsec.Owin](NWebsec.Owin.html): Register the middleware in the OWIN startup class:

```csharp
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXfo(options => options.SameOrigin());
}
```

[NWebsec.Mvc](NWebsec.Mvc.html): As an MVC attribute, defaults to policy="Deny":

```csharp
[XFrameOptions]
[XFrameOptions(Policy = XFrameOptionsPolicy.SameOrigin)]
```

The header is omitted for redirects.
