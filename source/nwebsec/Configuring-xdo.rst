Configuring X-Download-Options
==============================

There are two settings:

===============   ================
Configuration     Resulting header
===============   ================
enabled="false"   None
enabled="true"    X-Download-Options: noopen
===============   ================

Register the middleware in the OWIN startup class:

..  code-block:: c#

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
    {
        ...

        app.UseStaticFiles();

        app.UseXDownloadOptions();

        app.UseMvc(...);
    }

Or as an MVC attribute (which defaults to true):

..  code-block:: c#

    [XDownloadOptions]
    [XDownloadOptions(Enabled = false)]

The header is omitted for redirects.
