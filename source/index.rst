.. NWebsec documentation master file, created by
   sphinx-quickstart on Sun Oct 04 00:43:10 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

NWebsec - Security libraries for ASP.NET
========================================

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   Getting started <nwebsec/getting-started>
   nwebsec/libraries
   nwebsec/Configuration
   nwebsec/Breaking-changes


NWebsec consists of several security libraries for ASP.NET applications. Consult the [[Documentation]] to see how it works.

You'll find the NWebsec packages on NuGet:

* https://nuget.org/packages/NWebsec/
* https://nuget.org/packages/NWebsec.Mvc/
* https://nuget.org/packages/NWebsec.Owin/
* https://nuget.org/packages/NWebsec.SessionSecurity/
* https://nuget.org/packages/NWebsec.AzureStartupTasks/

NWebsec/NWebsec.Mvc lets you remove version headers, control cache headers, stop potentially dangerous redirects, and set important security headers. If you're not sure what "security headers" are, check out this blog post: `Security through HTTP response headers <http://www.dotnetnoob.com/2012/09/security-through-http-response-headers.html>`_.

NWebsec.Owin provides OWIN middleware to stop potentially dangerous redirects and set important security headers.

NWebsec.SessionSecurity improves ASP.NET session security. Read more about the improvements in the blog post `Ramping up ASP.NET session security <http://www.dotnetnoob.com/2013/07/ramping-up-aspnet-session-security.html>`_.

`NWebsec.AzureStartupTasks <https://github.com/NWebsec/NWebsec.AzureStartupTasks/wiki>`_ helps you harden the TLS configuration for Azure web role instances. Learn why you need to harden the default TLS configuration in the blog post `Hardening Windows Server 2008/2012 and Azure SSL/TLS configuration <http://www.dotnetnoob.com/2013/10/hardening-windows-server-20082012-and.html>`_.

Did you now that the SDL requires countermeasures against session fixation attacks, and that certain security headers must set by your web application? No? See [[NWebsec and the SDL]] to learn more.

Check out the `NWebsec demo site <http://www.nwebsec.com/>`_ to see the headers and session security improvements in action.

To keep up with new releases or to give feedback, find `@NWebsec <https://twitter.com/NWebsec>`_ on Twitter. You can also get in touch at nwebsec (at) nwebsec (dot) com.

.. Indices and tables
.. ==================

.. * :ref:`genindex`
.. * :ref:`modindex`
.. * :ref:`search`

