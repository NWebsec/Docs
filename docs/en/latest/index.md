---
title: "Home"
nav_order: 1
---

# NWebsec - Security libraries for ASP.NET Core


NWebsec consists of several security libraries for ASP.NET applications. These libraries work together to remove version headers, control cache headers, stop potentially dangerous redirects, and set important security headers. If you're not sure what "security headers" are, check out this blog post: [Security through HTTP response headers](http://www.dotnetnoob.com/2012/09/security-through-http-response-headers.html).

After the introduction of ASP.NET core, there are two sets of NWebsec packages. You've now found the documentation for the "new" packages built for ASP.NET Core:

- [NWebsec.AspNetCore.Middleware](https://nuget.org/packages/NWebsec.AspNetCore.Middleware /)
- [NWebsec.AspNetCore.Mvc](https://nuget.org/packages/NWebsec.AspNetCore.Mvc /)
- [NWebsec.AspNetCore.Mvc.TagHelpers](https://nuget.org/packages/NWebsec.AspNetCore.Mvc.TagHelpers /)

## NWebsec for ASP.NET 4

Historically, NWebsec has been targeting ASP.NET 4. The following packages target ASP.NET 4:

- [NWebsec](https://nuget.org/packages/NWebsec/)
- [NWebsec.Mvc](https://nuget.org/packages/NWebsec.Mvc/)
- [NWebsec.Owin](https://nuget.org/packages/NWebsec.Owin/)

Documentation for these packages is maintained separately as the [aspnet4 version](https://nwebsec.readthedocs.io/en/aspnet4/) of the docs.

There's also a dedicated session security library documented as a separate project.

- [NWebsec.SessionSecurity](https://nuget.org/packages/NWebsec.SessionSecurity/) / [documentation](http://docs.nwebsec.com/projects/SessionSecurity/en/latest/).

## NWebsec.AzureStartupTasks

In addition to the ASP.NET libraries, there's also a package that helps you harden the TLS configuration for Azure web role instances:

- [NWebsec.AzureStartupTasks](https://nwebsec.readthedocs.io/projects/AzureStartupTasks/en/latest/) / [documentation](https://nwebsec.readthedocs.io/projects/AzureStartupTasks/en/latest/).

Learn why you need to harden the default TLS configuration in the blog post [Hardening Windows Server 2008/2012 and Azure SSL/TLS configuration](http://www.dotnetnoob.com/2013/10/hardening-windows-server-20082012-and.html).

Check out the [NWebsec demo site](http://www.nwebsec.com/) to see the headers and session security improvements in action.

To keep up with new releases or to give feedback, find [@NWebsec](https://twitter.com/NWebsec) on Twitter. You can also get in touch at nwebsec (at) nwebsec (dot) com.
