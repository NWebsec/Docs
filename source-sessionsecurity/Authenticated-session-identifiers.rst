#################################
Authenticated session identifiers
#################################

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   AuthenticatedSessionIDManager

The NWebsec.SessionSecurity library offers protection against session fixation attacks on authenticated users in ASP.NET applications. Using the :doc:`AuthenticatedSessionIDManager`, session IDs are tightly coupled with the identity of the logged in user. The result: Session IDs cannot be reused across users.

************
How it works
************

The :doc:`AuthenticatedSessionIDManager` will check the following when creating/validating a session ID:

* Is sessionIDAuthentication enabled?
* Is the user authenticated? (Identity.IsAuthenticated == true)
* Is the user's name set? (Identity.Name != null or empty)

When all these checks are true an authenticated session ID will be created/validated. Else, it will fall back to the classic ASP.NET SessionIDManager behaviour.

This means that there is no dependency on how identities are set in your application, it will work for applications using Forms Authentication, Windows Identity Foundation, or Windows Authentication. It will also work if you have rolled your own custom solution for setting the user's identity on each request.

Note that cookieless session management is unsupported.

****************
Common scenarios
****************

We'll discuss the three possible scenarios for applications and user authentication.

Authenticated users only
========================

If your application requires all users to be authenticated, which is often the case for e.g. WIF enabled applications, then authenticated session IDs fit perfectly. All sessions would be authenticated, and you're certain that sessions cannot be shared by users.

Note that if the user already has an authenticated session ID lingering in the browser from a previous session, that will be reused for the next session. If the previous session has not timed out, any data from the previous session will also still be available. This aligns with the default behaviour for ASP.NET session state.

Both anonymous and authenticated users
======================================

If your application has open pages that rely on session and requires users to log in for certain functionality, authenticated session identifiers might break your application. An example would be an online shopping site where anonymous users add items to their shopping cart, which is stored in session. When the user logs in to pay for the goods, a new authenticated session would be created and the items in the shopping cart would be lost.  In these cases you would have to store the user's data through other means (to e.g. a database) when the user authenticates, and retrieve the data on (or after) the next request when the user gets the new authenticated session. Take care to properly validate any data that is brought from an unauthenticated session to an authenticated session!

Anonymous users only
====================
In this case there would be no authenticated sessions, and you'd get the regular ASP.NET session behaviour. In other words, no need to use the AuthenticatedSessionIDManager.
