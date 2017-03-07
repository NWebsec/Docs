Upgrade Insecure Requests
=========================

``upgrade-insecure-requests`` is the latest addition to the CSP directives, but note that it lives in a `separate specification <https://www.w3.org/TR/upgrade-insecure-requests/>`_. Though it looks very innocent and straight forward to configure, there are some important considerations before employing it.

The upgrade insecure requests CSP directive instructs browsers to upgrade all requests triggered by a page from HTTP to HTTPS. This lets site owners move legacy sites from HTTP to HTTPS without having to change every single link, and references to images, scripts and other content from HTTP to HTTPS to avoid mixed content issues.

.. note::
    
    Unless you're tasked with moving a legacy site that has been running on HTTP to HTTPS, and it has a bunch of hard coded references to HTTP resources on third party sites, ``upgrade-insecure-requests``
    is not what you want. For new sites, the upcoming `Mixed Content <https://www.w3.org/TR/mixed-content/>`_ specification would be a better fit.

How it works
------------

Say you have a site that has been running on http://www.example.com for years, and out of concern for your users' privacy you want to make the site available on https://www.example.com. You realize there's a daunting problem, http://www.example.com loads subresources (images, scripts etc.) from third party sites, these are all loaded over http:// and there's no easy way to change all those references to point to https://. These resources are regarded mixed content as soon as you move to https://www.example.com. The content is available over https:// on the third party sites, it's just that
your're not able to update every reference to it.

This is where ``upgrade-insecure-requests`` comes to the rescue. For browsers that support it, you can redirect users to https://www.example.com, and include a ``Content-Security-Policy: upgrade-insecure-requests`` header in the response. Conformant browsers will then load the page's resources from both same origin and third party sites over https://, and the mixed content problem goes away. The page and its subresources are all loaded over a (more) secure connection.

You need to detect browser support for the ``upgrade-insecure-requests`` CSP directive. Redirecting non-conforming browsers to https:// will result in the mixed content issues. Fortunately, browsers will advertise their support through a request header:

    Upgrade-Insecure-Requests: 1

When you enable the ``upgrade-insecure-requests`` directive in NWebsec, conforming browsers will be redirected to https with a 307 status code in accordance with the spec. The directive will always be included in the CSP header, as non-conforming browsers will ignore it.

This lets you gracefully move a legacy site from http to https as browser support for ``upgrade-insecure-requests`` improves over time.

Strict-Transport-Security
-------------------------
As users are moved to https on your site, the Strict-Transport-Security (HSTS) header can ensure that you keep them there. NWebsec supports setting the header only for UAs that support ``upgrade-insecure-requests``. This HSTS setting is useful in combination with ``upgrade-insecure-requests``, see :doc:`Configuring-hsts` for details.

Configuring Upgrade Insecure Requests
-------------------------------------

:doc:`NWebsec.AspNetCore.Middleware` lets you enable ``upgrade-insecure-requests`` through your OWIN startup class:

..  code-block:: c#

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
    {
        ...

        app.UseStaticFiles();

        app.UseCsp(opts => opts.UpgradeInsecureRequests());

        app.UseMvc(...);
    }

.. note::
    
    Remember to allow "same host redirects" if you're also using :doc:`Redirect-validation`.

    Also note that NWebsec relies on the ``Request.IsHttps`` property when determining whether to redirect from http to https. If you are behind a load balancer/reverse proxy that terminates the user's https connection you must ensure that these properties are set correctly.