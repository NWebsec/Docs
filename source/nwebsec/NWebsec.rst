#######
NWebsec
#######

NWebsec provides an `HTTP Module <https://msdn.microsoft.com/library/ms178468.aspx>`_ that controls which headers are sent in the response from an ASP.NET application. The HTTP Module works for both Web Forms application and MVC applications as it hooks into the `ASP.NET/IIS pipeline <http://msdn.microsoft.com/en-us/library/bb470252.aspx>`_. There, it makes changes to the HTTP header collection according to the NWebsec configuration.

The Http Module lets you set common security headers without any code changes, it is loaded and configured strictly through web.config.  This is a quick win for the security of ASP.NET applications. Security of legacy applications can be improved quite easily as well. The flexibility of the configuration means that various parts of an application can run with different configurations.

The NWebsec library is a "configuration only" install, it requires no code changes to your application. You'll find it on `NuGet <http://www.nuget.org/packages/NWebsec/>`_, or you can download the assemblies from the `GitHub releases <https://github.com/NWebsec/NWebsec/releases>`_. See :doc:`Configuration` to learn how to configure it.

****************
Security headers
****************

Supported security headers are:

* Content-Security-Policy / Content-Security-Policy-Report-Only
* Strict-Transport-Security
* Public-Key-Pins / Public-Key-Pins-Report-Only
* X-Frame-Options
* X-XSS-Protection
* X-Content-Type-Options
* X-Download-Options
