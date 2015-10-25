#########################
Configuring cache headers
#########################

Cache headers play an important role for your users' privacy if you're running a secure website. Browsers tend to cache web pages that the users loads, for easy retrieval and later display. Browser caching is an important mechanism to "speed up" up the Internet, to avoid having to fetch content that has not changed. 

In short the browser can behave in two ways when it comes to caching. It could ask the server whether a resource has changed, if not it can simply redisplay the page it has stored in cache. The browser can send the server an If-Modified-Since header to achieve this.

Also, the browser can serve previously loaded pages directly from cache — without checking with the server whether the page has changed. This is a common behaviour when the user is navigating back and forth with the "Back" and "Forward" buttons in the browser.

You can read an excellent write-up on the issues related to browser cache and history on Opera's Yngve Pettersen's blog: `Introducing Cache Contexts, or: Why the browser does not know you are logged out <https://vivaldi.net/userblogs/entry/introducing-cache-contexts-or-why-the>`_.

To instruct the browser to reload pages when the user is navigating with the back and forward buttons you can configure NWebsec to set the following headers: 

.. 

	Cache-Control: no-cache, no-store, must-revalidate  
	Expires: -1  
	Pragma: no-cache

NWebsec will not add these headers for content that typically should be cached:

* The WebResource.axd and ScriptResource.axd handlers that are commonly used in Web Forms applications. 
* Static content when the application is running in Integrated Pipeline mode.
* The "bundles" that were introduced in ASP.NET MVC 4.

.. 	warning::

	Setting these headers will make the browser reload every page in the browsing history when the user navigates with the "Back" and "Forward" buttons. This will affect the load on your server(s) — and also the user experience. Do not enable these headers unless you really have to. 

There are two ways to enable the cache control headers:

In web.config:

..	code-block:: xml

	<nwebsec>
	    <httpHeaderSecurityModule >
	        <setNoCacheHttpHeaders enabled="true" />
	    </httpHeaderSecurityModule >
	</nwebsec>

.. 	note::

	Enabling the no cache headers in config is a point of no return, as of NWebsec 3.0.0. This is by design after the PreSendRequestHeaders event was `deprecated by MSFT <http://www.asp.net/aspnet/overview/web-development-best-practices/what-not-to-do-in-aspnet,-and-what-to-do-instead#presend>`_. If you want to enable these headers globally for your app but make exceptions for some of your controllers/actions, use a global MVC filter instead, as per the following example.


Or as an MVC filter:

..	code-block:: c#

	public static void RegisterGlobalFilters(GlobalFilterCollection filters)
	{
	    filters.Add(new SetNoCacheHttpHeadersAttribute());
	}

You can also set the attribute on controllers and actions, see :doc:`NWebsec.Mvc`.