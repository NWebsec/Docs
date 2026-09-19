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

In web.config:

```xml
<x-Content-Type-Options enabled="false"/>
```

[NWebsec.Owin](NWebsec.Owin.html): Register the middleware in the OWIN startup class:

```csharp
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXContentTypeOptions();
}
```

Or as an MVC attribute (which defaults to true):

```csharp
[XContentTypeOptions]
[XContentTypeOptions(Enabled = false)]
```

The header is omitted for redirects.
