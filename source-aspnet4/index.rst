.. NWebsec documentation master file, created by
   sphinx-quickstart on Sun Oct 04 00:43:10 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

NWebsec classic - Security libraries for ASP.NET 4
==================================================

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   Getting started <nwebsec/getting-started>
   NWebsec libraries <nwebsec/libraries>
   Configuration <nwebsec/Configuration>
   Breaking changes <nwebsec/Breaking-changes>
   nwebsec/NWebsec-and-the-SDL


NWebsec consists of several security libraries for ASP.NET applications. Three of these libraries work together to remove version headers, control cache headers, stop potentially dangerous redirects, and set important security headers. With the introduction of ASP.NET core, there are two sets of NWebsec packages. You've now found the documentation for the "old" packages built for ASP.NET 4:

* `NWebsec <https://nuget.org/packages/NWebsec/>`_
* `NWebsec.Mvc <https://nuget.org/packages/NWebsec.Mvc/>`_
* `NWebsec.Owin <https://nuget.org/packages/NWebsec.Owin/>`_

If you're not sure what "security headers" are, check out this blog post: `Security through HTTP response headers <http://www.dotnetnoob.com/2012/09/security-through-http-response-headers.html>`_.

There are also two stand-alone libraries. Since they don't follow the versions of the security header libraries, they are documented as separate projects. 

* `NWebsec.SessionSecurity <https://nuget.org/packages/NWebsec.SessionSecurity/>`_ - `docs here <http://docs.nwebsec.com/projects/SessionSecurity/en/latest/>`_.
* `NWebsec.AzureStartupTasks <https://nuget.org/packages/NWebsec.AzureStartupTasks/>`_ - `docs here <http://docs.nwebsec.com/projects/AzureStartupTasks/en/latest/>`_.

NWebsec.SessionSecurity improves ASP.NET session security. Read more about the improvements in the blog post `Ramping up ASP.NET session security <http://www.dotnetnoob.com/2013/07/ramping-up-aspnet-session-security.html>`_.

`NWebsec.AzureStartupTasks <https://github.com/NWebsec/NWebsec.AzureStartupTasks/wiki>`_ helps you harden the TLS configuration for Azure web role instances. Learn why you need to harden the default TLS configuration in the blog post `Hardening Windows Server 2008/2012 and Azure SSL/TLS configuration <http://www.dotnetnoob.com/2013/10/hardening-windows-server-20082012-and.html>`_.

Check out the `NWebsec demo site <http://www.nwebsec.com/>`_ to see the headers and session security improvements in action.

To keep up with new releases or to give feedback, find `@NWebsec <https://twitter.com/NWebsec>`_ on Twitter. You can also get in touch at nwebsec (at) nwebsec (dot) com.

.. Indices and tables
.. ==================

.. * :ref:`genindex`
.. * :ref:`modindex`
.. * :ref:`search`

