.. NWebsec documentation master file, created by
   sphinx-quickstart on Sun Oct 04 00:43:10 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

NWebsec - Security libraries for ASP.NET Core
=============================================

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   Getting started <nwebsec/getting-started>
   NWebsec libraries <nwebsec/libraries>
   Configuration <nwebsec/Configuration>
   Breaking changes <nwebsec/Breaking-changes>
   nwebsec/NWebsec-and-the-SDL
   nwebsec/core-vs-classic


NWebsec consists of several security libraries for ASP.NET applications. These libraries work together to remove version headers, control cache headers, stop potentially dangerous redirects, and set important security headers. If you're not sure what "security headers" are, check out this blog post: `Security through HTTP response headers <http://www.dotnetnoob.com/2012/09/security-through-http-response-headers.html>`_.

After the introduction of ASP.NET core, there are two sets of NWebsec packages. You've now found the documentation for the "new" packages built for ASP.NET Core: 

* `NWebsec.AspNetCore.Middleware  <https://nuget.org/packages/NWebsec.AspNetCore.Middleware />`_
* `NWebsec.AspNetCore.Mvc  <https://nuget.org/packages/NWebsec.AspNetCore.Mvc />`_
* `NWebsec.AspNetCore.Mvc.TagHelpers  <https://nuget.org/packages/NWebsec.AspNetCore.Mvc.TagHelpers />`_

NWebsec for ASP.NET 4
---------------------
Historically, NWebsec has been targeting ASP.NET 4. The following packages target ASP.NET 4:

* `NWebsec <https://nuget.org/packages/NWebsec/>`_
* `NWebsec.Mvc <https://nuget.org/packages/NWebsec.Mvc/>`_
* `NWebsec.Owin <https://nuget.org/packages/NWebsec.Owin/>`_

Documentation for these packages is maintained separately as the `aspnet4 version <https://docs.nwebsec.com/en/aspnet4/>`_ of the docs.

There's also a dedicated session security library documented as a separate project. 

* `NWebsec.SessionSecurity <https://nuget.org/packages/NWebsec.SessionSecurity/>`_ / `documentation <http://docs.nwebsec.com/projects/SessionSecurity/en/latest/>`_.

NWebsec.AzureStartupTasks
-------------------------
In addition to the ASP.NET libraries, there's also a package that helps you harden the TLS configuration for Azure web role instances:

* `NWebsec.AzureStartupTasks <https://docs.nwebsec.com/projects/AzureStartupTasks/en/latest/>`_ / `documentation <https://docs.nwebsec.com/projects/AzureStartupTasks/en/latest/>`_.

Learn why you need to harden the default TLS configuration in the blog post `Hardening Windows Server 2008/2012 and Azure SSL/TLS configuration <http://www.dotnetnoob.com/2013/10/hardening-windows-server-20082012-and.html>`_.

Check out the `NWebsec demo site <http://www.nwebsec.com/>`_ to see the headers and session security improvements in action.

To keep up with new releases or to give feedback, find `@NWebsec <https://twitter.com/NWebsec>`_ on Twitter. You can also get in touch at nwebsec (at) nwebsec (dot) com.

.. Indices and tables
.. ==================

.. * :ref:`genindex`
.. * :ref:`modindex`
.. * :ref:`search`

