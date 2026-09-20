---
title: "Home"
nav_order: 1
---

# NWebsec classic - Security libraries for ASP.NET 4


NWebsec consists of several security libraries for ASP.NET applications. Three of these libraries work together to remove version headers, control cache headers, stop potentially dangerous redirects, and set important security headers. With the introduction of ASP.NET core, there are two sets of NWebsec packages. You've now found the documentation for the "old" packages built for ASP.NET 4:

- [NWebsec](https://nuget.org/packages/NWebsec/)
- [NWebsec.Mvc](https://nuget.org/packages/NWebsec.Mvc/)
- [NWebsec.Owin](https://nuget.org/packages/NWebsec.Owin/)

If you're not sure what "security headers" are, check out this blog post: [Security through HTTP response headers](http://www.dotnetnoob.com/2012/09/security-through-http-response-headers.html).

There are also two stand-alone libraries. Since they don't follow the versions of the security header libraries, they are documented as separate projects.

- [NWebsec.SessionSecurity](https://nuget.org/packages/NWebsec.SessionSecurity/) - [docs here](/projects/SessionSecurity/en/latest/).
- [NWebsec.AzureStartupTasks](https://nuget.org/packages/NWebsec.AzureStartupTasks/) - [docs here](/projects/AzureStartupTasks/en/latest/).

NWebsec.SessionSecurity improves ASP.NET session security. Read more about the improvements in the blog post [Ramping up ASP.NET session security](http://www.dotnetnoob.com/2013/07/ramping-up-aspnet-session-security.html).

To keep up with new releases or to give feedback, find [@NWebsec](https://x.com/NWebsec) on X.

## Looking for the ASP.NET Core docs?

This documentation covers the classic ASP.NET 4 packages (`NWebsec`, `NWebsec.Mvc`, `NWebsec.Owin`). For the current ASP.NET Core packages, see the [main NWebsec documentation](/en/latest/).
