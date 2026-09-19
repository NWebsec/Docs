---
title: "X-Download-Options"
nav_order: 11
parent: "Configuration"
---

# Configuring X-Download-Options

There are two settings:

| Configuration   | Resulting header           |
|-----------------|----------------------------|
| enabled="false" | None                       |
| enabled="true"  | X-Download-Options: noopen |

In web.config:

```xml
<x-Download-Options enabled="false"/>
```

[NWebsec.Owin](NWebsec.Owin.html): Register the middleware in the OWIN startup class:

```csharp
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXDownloadOptions();
}
```

Or as an MVC attribute (which defaults to true):

```csharp
[XDownloadOptions]
[XDownloadOptions(Enabled = false)]
```

The header is omitted for redirects.
