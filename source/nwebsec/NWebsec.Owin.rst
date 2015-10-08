############
NWebsec.Owin
############

NWebsec.Owin provides OWIN middleware that lets you output HTTP security headers. It currently supports:

* Strict-Transport-Security
* X-Content-Type-Options
* X-Download-Options
* X-Frame-Options
* X-Xss-Protection
* Content-Security-Policy
* X-Robots-Tag

In addition, it provides middleware for redirect validation.

You'll notice that not all features from the :doc:`NWebsec` library are available yet, e.g. cache-headers, these are under consideration.

************
Dependencies
************
NWebsec.Owin depends on the [OWIN NuGet package](http://www.nuget.org/packages/Owin/) and the OWIN IAppBuilder startup interface defined there. It does not have any [Katana](http://www.asp.net/aspnet/overview/owin-and-katana) (MSFTs OWIN libraries) dependencies. The idea is to be able to support other OWIN host implementations as they become available.

Note that the middleware has been developed and tested under Katana.

*************
Documentation
*************

The middleware is documented alongside the web.config and MVC attributes. Refer to the [[NWebsec]] documentation for samples.
