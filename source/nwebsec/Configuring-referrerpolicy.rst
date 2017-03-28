Configuring Referrer-Policy
===========================
See `Referrer Policy - MDN <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy>`_ for a detailed description on various referrer policies.

This header can be configured as such:

===========================		================================================
Configuration					Resulting header
===========================		================================================
Disabled						None
NoReferrer						Referrer-Policy: no-referrer
NoReferrerWhenDowngrade			Referrer-Policy: no-referrer-when-downgrade
SameOrigin						Referrer-Policy: same-origin
Origin							Referrer-Policy: origin
StrictOrigin					Referrer-Policy: strict-origin
OriginWhenCrossOrigin			Referrer-Policy: origin-when-cross-origin
StrictOriginWhenCrossOrigin		Referrer-Policy: strict-origin-when-cross-origin
UnsafeUrl						Referrer-Policy: unsafe-url
===========================		================================================

Register the middleware in the startup class:

..  code-block:: c#

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
    {
        ...
        
        app.UseReferrerPolicy(opts => opts.NoReferrer());

        app.UseStaticFiles();

        app.UseMvc(...);
    }

As an MVC attribute, defaults to policy="Deny":

..  code-block:: c#
    
    [ReferrerPolicy(ReferrerPolicy.NoReferrer)]

Set referrer policy in a `<meta>` tag:

..  code-block:: html

       <meta name="referrer" nws-referrerpolicy="NoReferrer"/>

