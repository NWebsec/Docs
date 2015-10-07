Every now an then there needs to be some breaking changes between NWebsec versions. You'll find them documented here.

### NWebsec 4.x / NWebsec.Owin 2.x

#### Removed support for the X-Content-Security-Policy and X-WebKit-Csp headers
Browser CSP implementations that honor these experimental headers tend to be buggy. The worst example being Safari 5, which often would completely break the site.

* You'll get a configuration error if you have these enabled in web.config
* You'll get a compilation error if you have these enabled through MVC attributes

#### Removed/moved all types from the **NWebsec.Csp** namespace
Consequently, the following using statement will trigger a compilation error: 

```c#
using NWebsec.Csp;
```

You can safely remove it from your code. This was legacy from the very first versions of NWebsec.

#### CSP attribute source configuration.

With NWebsec.Mvc versions < 4 you would configure CSP sources with an enum. This made the code unnecessarily hard to read.

```c#
[CspDefaultSrc(Self = Source.Enable)]
[CspDefaultSrc(Self = Source.Disable)]
```

As of version four you configure them with a boolean. This makes makes the code easier to read.

```c#
[CspDefaultSrc(Self = true)]
[CspDefaultSrc(Self = false)]
```

You can easily update your code by doing a search and replace for these.

#### HSTS - Strict Transport Security
NWebsec has not been completely in line with the HSTS specification which states that the header should only be set over secure connections. The default for NWebsec has now been changed for the sake of consistency with the upcoming support for HPKP which also should be set over secure connections only.

This means that the header might not be set if you're using a TLS terminator, which communicates with your website over plain HTTP. You can still set the header in this scenario, but you must specifically enable it.

To enable it for all responses you must set the httpsOnly attribute to false in web.config

```xml
<strict-Transport-Security ... httpsOnly="false"/>
```

Or you specify that it should be included in all responses for the OWIN middleware:

```c#
app.UseHsts(options => options.MaxAge(days:18*7).AllResponses());
```

### NWebsec 3.x

The  `<suppressVersionHttpHeaders>`  configuration setting is no longer supported.