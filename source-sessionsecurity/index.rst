.. NWebsec documentation master file, created by
   sphinx-quickstart on Sun Oct 04 00:43:10 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

###############################################
NWebsec - Improved session security for ASP.NET
###############################################

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   Configuring-session-security
   Authenticated-session-identifiers


The NWebsec.SessionSecurity library improves ASP.NET session security by enforcing a strong binding between an authenticated user's identity and the user's session identifier.

You'll find the library on NuGet: `NWebsec.SessionSecurity <http://nuget.org/packages/NWebsec.SessionSecurity/>`_. You can also get it under `Releases <https://github.com/NWebsec/NWebsec.SessionSecurity/releases>`_ over at GitHub.

To learn more about how it works, see :doc:`Authenticated-session-identifiers`. To see how it's configured, refer to :doc:`Configuring-session-security`. 

For background on why the library improves security, see the blog post `Ramping up ASP.NET session security <http://www.dotnetnoob.com/2013/07/ramping-up-aspnet-session-security.html>`_.

Did you now that the SDL requires countermeasures against session fixation attacks, and that certain security headers must set by your web application? No? See :doc:`` to learn more.

Check out the `NWebsec demo site <http://www.nwebsec.com/>`_ to see the headers and session security improvements in action.

To keep up with new releases or to give feedback, find `@NWebsec <https://twitter.com/NWebsec>`_ on Twitter. You can also get in touch at nwebsec (at) nwebsec (dot) com.

