#########################
Configuring cache headers
#########################

Cache headers play an important role for your users' privacy if you're running a secure website. Browsers tend to cache web pages that the users loads, for easy retrieval and later display. Browser caching is an important mechanism to "speed up" up the Internet, to avoid having to fetch content that has not changed. 

In short the browser can behave in two ways when it comes to caching. It could ask the server whether a resource has changed, if not it can simply redisplay the page it has stored in cache. The browser can send the server an If-Modified-Since header to achieve this.

Also, the browser can serve previously loaded pages directly from cache — without checking with the server whether the page has changed. This is a common behaviour when the user is navigating back and forth with the "Back" and "Forward" buttons in the browser.

You can read an excellent write-up on the issues related to browser cache and history on Opera's Yngve Pettersen's blog: `Introducing Cache Contexts, or: Why the browser does not know you are logged out <https://vivaldi.net/userblogs/entry/introducing-cache-contexts-or-why-the>`_.

To instruct the browser to reload pages when the user is navigating with the back and forward buttons you can configure NWebsec to set the following headers::

	Cache-Control: no-cache, no-store, must-revalidate
	Expires: -1
	Pragma: no-cache

.. 	warning::

	Setting these headers will make the browser reload every page in the browsing history when the user navigates with the "Back" and "Forward" buttons. This will affect the load on your server(s) — and also the user experience. Do not enable these headers unless you really have to. 

Middleware
----------

..	code-block:: c#

	public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
        	...

            app.UseStaticFiles();

            app.UseNoCacheHttpHeaders(); //Registered after static files, to set headers only for dynamic content.
            
            app.UseMvc(...);
        }

.. 	note::

	Enabling the no cache headers in middleware is a point of no return. If you want to enable these headers globally for your app but make exceptions for some of your controllers/actions, use a global MVC filter instead, as per the following example.


MVC filter
----------

..	code-block:: c#

	...
    using NWebsec.AspNetCore.Mvc;
    using NWebsec.AspNetCore.Mvc.Csp;

    ....

    public void ConfigureServices(IServiceCollection services)
    {
        // Add framework services.
        services.AddMvc(opts =>
        {
            opts.Filters.Add(typeof(NoCacheHttpHeadersAttribute));
        });
    }

You can also set the attribute on controllers and actions, see :doc:`NWebsec.AspNetCore.Mvc`.