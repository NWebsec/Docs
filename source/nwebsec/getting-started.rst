Getting started with NWebsec
============================

NWebsec lets you configure quite a few security headers, some are useful for most applications while others are a bit more specialized. Here's some guidance to get you started.

First, you need to add NWebsec to your application. The easiest way to do this would be to get it through NuGet. Search for *NWebsec* in the package manager GUI, or install it through the console with one of the following commands:

For an ASP.NET core app:

..  code-block:: powershell

    Install-Package NWebsec.AspNetCore.Middleware

If you'd want to use the MVC attributes

..  code-block:: powershell

    Install-Package NWebsec.AspNetCore.Mvc

And if you'd want to use the MVC tag helpers

..  code-block:: powershell

    Install-Package NWebsec.AspNetCore.Mvc.TagHelpers


Now it's time to start securing your application! It's good practice to not leak information through the referer (sic.) header, this is managed with the `Referrer-Policy` header.

To avoid various attacks carried out through iframes, the `X-Frame-Options header` should be enabled. MIME sniffing is a source to many problems, including security issues, so you'd want to run with the `X-Content-Type-Options header`.

For applications that run over SSL/TLS, you should most definitely employ the `Strict-Transport-Security header` — instructing the browser to interact with anything on your domain over a secured connection only.

Unless your application needs to redirect users to arbitrary sites on the internet, you'd want *redirect validation* enabled. There might be a few sites you'd want to whitelist for redirects, in particular if you use WIF or Google/Facebook/any other external authentication provider. Consult :doc:`Redirect-validation` if you run into trouble.

So, for an application running over http the following is a reasonable starting point for based on the `Startup.cs` from the ASP.NET Core MVC webapp template:

..  code-block:: c#

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
    {
        loggerFactory.AddConsole(Configuration.GetSection("Logging"));
        loggerFactory.AddDebug();

        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
            app.UseBrowserLink();
        }
        else
        {
            app.UseExceptionHandler("/Home/Error");
        }

        //Registered before static files to always set header
        app.UseXContentTypeOptions();
        app.UseReferrerPolicy(opts => opts.NoReferrer());


        app.UseStaticFiles();

        //Registered after static files, to set headers for dynamic content.
        app.UseXfo(xfo => xfo.Deny());
        app.UseRedirectValidation(); //Register this earlier if there's middleware that might redirect.

        app.UseMvc(routes =>
        {
            routes.MapRoute(
                name: "default",
                template: "{controller=Home}/{action=Index}/{id?}");
        });
    }

If your site is served over https, you'd also want to include the Strict-Transport-Security header, as such (note that the browser will load all content over https for the entire domain when the header is used):

..  code-block:: c#

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
    {
        loggerFactory.AddConsole(Configuration.GetSection("Logging"));
        loggerFactory.AddDebug();

        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
            app.UseBrowserLink();
        }
        else
        {
            app.UseExceptionHandler("/Home/Error");
        }

        //Registered before static files to always set header
        app.UseHsts(hsts => hsts.MaxAge(365));
        app.UseXContentTypeOptions();
        app.UseReferrerPolicy(opts => opts.NoReferrer());

        app.UseStaticFiles();

        //Registered after static files, to set headers for dynamic content.
        app.UseXfo(xfo => xfo.Deny());
        app.UseRedirectValidation(); //Register this earlier if there's middleware that might redirect.

        app.UseMvc(routes =>
        {
            routes.MapRoute(
                name: "default",
                template: "{controller=Home}/{action=Index}/{id?}");
        });
    }

**Note!** If users can log into you application, you should always run it over https to keep your users safe!

NWebsec lets you add other security headers as well, but these are more tightly coupled to the individual resources in your application. In particular, the *Content-Security-Policy (CSP) header* can significantly improve the security of a web application but also requires great care when you're building a new application from the ground up — even more so if you retrofit it onto an existing application. SendSafely has published two blog posts discussing how they dealt with the challenge, links included for the interested reader:

* `Using Content Security Policy to Prevent Cross-Site Scripting (XSS) <https://blog.sendsafely.com/post/42277333593/using-content-security-policy-to-prevent-cross-site>`_
* `Retrofitting Code for Content Security Policy <https://blog.sendsafely.com/post/50303516209/retrofitting-code-for-content-security-policy>`_

See :doc:`Configuring-csp` to learn how to enable CSP, this is where the real job starts. Good luck! :)

Note also that security headers can be enabled through MVC attributes, refer to :doc:`NWebsec.AspNetCore.Mvc` for details.
