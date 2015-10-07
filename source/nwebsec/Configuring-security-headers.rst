Here's the complete overview of how the http headers are configured, and what the output will be.

* [Strict-Transport-Security](#strict-transport-security)
* [Public-Key-Pins](#public-key-pins)
* [X-Frame-Options](#x-frame-options)
* [X-Content-Type-Options](#x-content-type-options)
* [X-Download-Options](#x-download-options)
* [X-XSS-Protection](#x-xss-protection)
* Content-Security-Policy / Content-Security-Policy-Report-Only
  

The Content Security Policy headers have a more complex configuration than the other headers so they deserve special treatment, see: [[Configuring Content Security Policy]]

----
## Strict-Transport-Security
There are four configuration options

* _max-age_ is a TimeSpan (see [TimeSpan.Parse](http://msdn.microsoft.com/en-us/library/se73z7b9.aspx))
* _includeSubdomains_ adds *includeSubDomains* in the header, defaults to *false*
* _preload_ adds the *preload* directive, defaults to *false*. Max-age must be at least 18 weeks, and includeSubdomains must be enabled to use the preload directive. See the [Chromium HSTS docs](http://www.chromium.org/sts) for details.
* _httpsOnly_ ensures that the HSTS header is set over secure connections only, defaults to *true*. 

| Configuration | Resulting header|
| ---- | ---- |
| max-age="00:00:00" | Strict-Transport-Security: max-age=0 |
| max-age="12:00:00" | Strict-Transport-Security: max-age=43200 |
| max-age="365" includeSubdomains="true" | Strict-Transport-Security: max-age=31536000; includeSubDomains |
| max-age="365" includeSubdomains="true" preload="true" | Strict-Transport-Security: max-age=31536000; includeSubDomains; preload |

In web.config:

```xml
<strict-Transport-Security max-age="365" />
<strict-Transport-Security max-age="00:30:00" includeSubdomains="true" />
<strict-Transport-Security max-age="365" includeSubdomains="true" preload="true"/>
```

[[NWebsec.Owin]]: Register the middleware in the OWIN startup class:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseHsts(options => options.MaxAge(days:30).IncludeSubdomains());
    //app.UseHsts(options => options.MaxAge(days:365).IncludeSubdomains().Preload());
}
```
----
## Public-Key-Pins
There are four configuration options, as well as a list of certs to pin and/or a list of pin values. Note that you must supply two pins to generate a valid header, i.e. two certs, a cert and a pin value, or two pin values.

* _max-age_ is a TimeSpan (see [TimeSpan.Parse](http://msdn.microsoft.com/en-us/library/se73z7b9.aspx))
* _includeSubdomains_ adds *includeSubDomains* in the header, defaults to *false*
* _httpsOnly_ ensures that the HSTS header is set over secure connections only, defaults to *true*. 
* _reportUri_ specifies an absolute URI to where the browser can report HPKP violations. The scheme must be HTTP or HTTPS. 
* _certificates_ specifies a list of certificates (by thumbprints) that should be pinned. 
* _pins_ specifies a list of pinning values for certificates that should be pinned

The following examples assume that we supply the pinning values: n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE= and d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=

| Configuration | Resulting header|
| ---- | ---- |
| max-age="00:00:00" | Public-Key-Pins: max-age=0 |
| max-age="12:00:00" | Public-Key-Pins: max-age=43200;pin-sha256="n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE=";pin-sha256="d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=" |
| max-age="365" includeSubdomains="true" | Public-Key-Pins: max-age=31536000;includeSubdomains;pin-sha256="n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE=";pin-sha256="d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=" |
| max-age="365" includeSubdomains="true" report-uri="https://report.nwebsec.com/ | Public-Key-Pins: max-age=1;includeSubdomains;pin-sha256="n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE=";pin-sha256="d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=";report-uri="https://report.nwebsec.com/" |

In web.config:

```xml
<public-Key-Pins max-age="30" includeSubdomains="true">
  <certificates>
    <add thumbprint="FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF"/>
  </certificates>
  <pins>
    <add pin="Base64 pin"/>
  </pins>
</public-Key-Pins>
<public-Key-Pins-Report-Only max-age="00:00:10"  report-uri="https://report.nwebsec.com/">
  <certificates>
    <add thumbprint="00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" />
    <add thumbprint="01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01" />
  </certificates>
</public-Key-Pins-Report-Only>
```

[[NWebsec.Owin]]: Register the middleware in the OWIN startup class:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseHpkp(options => options
        .MaxAge(seconds: 20)
        .Sha256Pins("d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=")
        .PinCertificate("FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF")
        .ReportUri("https://nwebsec.com/report")
        );
}
```
----
## X-Frame-Options
This header can be configured in three ways:

| Configuration | Resulting header|
| ------ | ----- |
| policy="Disabled" | None |
| policy="Deny" | X-Frame-Options: Deny |
| policy="SameOrigin" | X-Frame-Options: SameOrigin |

[[NWebsec]]: In web.config

```xml 
<x-Frame-Options policy="Disabled"/>
```

[[NWebsec.Owin]]: Register the middleware in the OWIN startup class:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXfo(options => options.SameOrigin());
}
```

[[NWebsec.Mvc]]: As an MVC attribute, defaults to policy="Deny":

```c#
[XFrameOptions]
[XFrameOptions(Policy = XFrameOptionsPolicy.SameOrigin)]
```

The header is omitted for redirects.

----
## X-Content-Type-Options
There are two settings:

| Configuration | Resulting header |
| --- | --- |
| enabled="false" | None |
| enabled="true" | X-Content-Type-Options: nosniff |

In web.config:

```xml
<x-Content-Type-Options enabled="false"/>
```

[[NWebsec.Owin]]: Register the middleware in the OWIN startup class:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXContentTypeOptions();
}
```

Or as an MVC attribute (which defaults to true):

```
[XContentTypeOptions]
[XContentTypeOptions(Enabled = false)]
```

The header is omitted for redirects.

----
## X-Download-Options
There are two settings:

| Configuration | Resulting header|
| --- | --- |
| enabled="false" | None |
| enabled="true" | X-Download-Options: noopen |

In web.config:

```xml
<x-Download-Options enabled="false"/>
```

[[NWebsec.Owin]]: Register the middleware in the OWIN startup class:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXDownloadOptions();
}
```

Or as an MVC attribute (which defaults to true):

```c#
[XDownloadOptions]
[XDownloadOptions(Enabled = false)]
```

The header is omitted for redirects.

----
## X-XSS-Protection
There are two configuration options

* _policy_ is can be set to :
** Disabled
** FilterDisabled
** FilterEnabled
* _blockMode_ adds *mode=block* in the header, defaults to *false*

| Configuration | Resulting header|
| ---- | ---- |
| policy="Disabled" | None |
| policy="FilterDisabled" | X-XSS-Protection: 0 |
| policy="FilterEnabled" blockMode="true" | X-XSS-Protection: 1; mode=block |

In web.config:

```xml
<x-XSS-Protection policy="FilterEnabled" blockMode="true"/>
<x-XSS-Protection policy="FilterDisabled" />
```

[[NWebsec.Owin]]: Register the middleware in the OWIN startup class:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseXXssProtection(options => options.EnabledWithBlockMode());
}
```

Or as an MVC attribute, defaults to "FilterDisabled" blockMode="true":

```c#
[XXssProtection]
[XXssProtection(Policy = XXssProtectionPolicy.Disabled)]
```

The header is omitted for redirects and static content.