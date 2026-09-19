NWebsec libraries (ASP.NET 4)
=============================

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   NWebsec <NWebsec>
   NWebsec.Owin <NWebsec.Owin>
   NWebsec.Mvc <NWebsec.Mvc>

NWebsec is made up of several libraries, each offering different approaches to improve the security of your web applications.

*******
NWebsec
*******
:doc:`NWebsec` lets you add security headers and other features to your applications through an HTTP module that is loaded and configured through web.config. This makes it fairly easy to improve the security of legacy apps, as it requires no changes to code.

************
NWebsec.Owin
************
:doc:`NWebsec.Owin` offers OWIN middleware for many of NWebsec's features.

***********
NWebsec.Mvc
***********
:doc:`NWebsec.Mvc` configures NWebsec through MVC attributes. This is useful when you need to do adjustments to the application wide config from NWebsec/NWebsec.Owin, for particular controllers or actions. Some developers prefer to minimize their web.config, and configure most things through code. They can use the NWebsec.Mvc attributes as an alternative to web.config for most features.

