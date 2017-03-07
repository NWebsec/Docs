Configuring X-Content-Type-Options
==================================

There are two settings:

===============  ================
Configuration    Resulting header
===============  ================
enabled="false"  None
enabled="true"   X-Content-Type-Options: nosniff
===============  ================

Register the middleware in the OWIN startup class:

..  code-block:: c#

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
    {
        ...

        app.UseStaticFiles();

        app.UseXContentTypeOptions();

        app.UseMvc(...);
    }

Or as an MVC attribute (which defaults to true):

..  code-block:: c#

  [XContentTypeOptions]
  [XContentTypeOptions(Enabled = false)]

The header is omitted for redirects.
