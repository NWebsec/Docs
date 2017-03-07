Redirect validation
===================

If you're familiar with the `OWASP top ten list <https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project>`_ you'll know that *Unvalidated Redirects and Forwards* has been lingering as number ten on that list the last couple of years. These types of vulnerabilities are used in real attacks but fortunately there are several ways to deal with them. You'll find a nice write-up on the issues and potential countermeasures here: `OWASP Top 10 for .NET developers part 10: Unvalidated Redirects and Forwards <http://www.troyhunt.com/2011/12/owasp-top-10-for-net-developers-part-10.html>`_.

The proper remedy for unvalidated redirects lie in the code. Whenever an application redirects the user based on input parameters, that input should be validated. As we all know, developers slip once in a while. Legacy applications can also pose a challenge, with code written during a time where security might not have been a priority. Having a "safety net" to help detect and fix such vulnerabilities makes it easier to keep the code base secure.

Redirect validation is slightly opportunistic. In most cases, the redirect validation exception will be thrown before the response headers are sent to the client. However, if the response is flushed early the headers will be sent to the client immediately. An exception will be thrown in any case if a non-whitelisted redirect is detected.

Configuring redirect validation
*******************************

:doc:`NWebsec.AspNetCore.Middleware` lets you enable redirect validation with a single line in your startup class:

..  code-block:: c#

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            ...

            app.UseStaticFiles();

            app.UseRedirectValidation(); //Registered after static files, they don't redirect

            app.UseMvc(...);
        }

This configuration will validate all HTTP responses with a status code of 3xx, except 304 (Not Modified). Redirects to relative URIs are allowed, as well as redirects to the same site — meaning the same scheme/host/port. Redirects to other destinations will trigger a *RedirectValidationException*, terminating the response.

..  note::

    Make sure to register the redirect validation middleware reasonably early in the pipeline. The middleware will not be called if a preceding middleware redirects and terminates the pipeline.

Web applications often redirect users from HTTP to HTTPS, this must be explicitly allowed. If the site is running on a non-default HTTPS port, one or more port numbers must be configured. Also, if your application needs to redirect to other sites they can be added to a whitelist in config, as such:

..  code-block:: c#

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            ...

            app.UseStaticFiles();

            app.UseRedirectValidation(opts =>
            {
                opts.AllowSameHostRedirectsToHttps();
                //opts.AllowSameHostRedirectsToHttps(4430); Allow redirects to custom HTTPS port
                opts.AllowedDestinations("http://www.nwebsec.com/", "https://www.google.com/accounts/");
            });

            app.UseMvc(...);
        }

In addition to same site redirects, this would allow redirects to anywhere on *http://www.nwebsec.com/* as well as *https://www.google.com/accounts/* and subpaths. Redirects to other destinations will trigger an exception.

As an example based on the above configuration, a redirect to *https://www.google.com/accounts/foo/bar* would be allowed but a redirect to *https://www.google.com/foo/* would raise an exception.

