NWebsec libraries
=================

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   NWebsec.AspNetCore.Middleware <NWebsec.AspNetCore.Middleware>
   NWebsec.AspNetCore.Mvc <NWebsec.AspNetCore.Mvc>
   NWebsec.AspNetCore.Mvc.TagHelpers <NWebsec.AspNetCore.Mvc.TagHelpers>

NWebsec is made up of several libraries, each offering different approaches to improve the security of your web applications.

NWebsec Middleware
------------------
:doc:`NWebsec.AspNetCore.Middleware` offers ASP.NET Core middleware for many of NWebsec's features.

NWebsec for Mvc
---------------
:doc:`NWebsec.AspNetCore.Mvc` configures NWebsec through MVC attributes. This is useful when you need to do adjustments to the application wide config from NWebsec.AspNetCore.Middleware for particular controllers or actions.

NWebsec TagHelpers
------------------
:doc:`NWebsec.AspNetCore.Mvc.TagHelpers` lets you add content specific security settings, such as CSP nonces, straight in your Razr views. 
