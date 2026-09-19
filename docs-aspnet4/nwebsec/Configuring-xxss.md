---
title: "X-Xss-Protection"
nav_order: 9
parent: "Configuration"
---

# Configuring X-XSS-Protection

There are two configuration options

- **policy** can be set to :
  - Disabled
  - FilterDisabled
  - FilterEnabled
- **blockMode** adds *mode=block* in the header, defaults to *false*

| Configuration                           | Resulting header                |
|-----------------------------------------|---------------------------------|
| policy="Disabled"                       | None                            |
| policy="FilterDisabled"                 | X-XSS-Protection: 0             |
| policy="FilterEnabled" blockMode="true" | X-XSS-Protection: 1; mode=block |

In web.config:

```xml
<x-XSS-Protection policy="FilterEnabled" blockMode="true"/>
<x-XSS-Protection policy="FilterDisabled" />
```

[NWebsec.Owin](NWebsec.Owin.html): Register the middleware in the OWIN startup class:

```csharp
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXXssProtection(options => options.EnabledWithBlockMode());
}
```

Or as an MVC attribute, defaults to "FilterDisabled" blockMode="true":

```csharp
[XXssProtection]
[XXssProtection(Policy = XXssProtectionPolicy.Disabled)]
```

The header is omitted for redirects and static content.
