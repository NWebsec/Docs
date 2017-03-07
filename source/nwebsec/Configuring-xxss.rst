Configuring X-XSS-Protection
============================

There are two configuration options

* **policy** can be set to :

  * Disabled
  * FilterDisabled
  * FilterEnabled

* **blockMode** adds *mode=block* in the header, defaults to *false*

=======================================   ================
Configuration                             Resulting header
=======================================   ================
policy="Disabled"                         None
policy="FilterDisabled"                   X-XSS-Protection: 0
policy="FilterEnabled" blockMode="true"   X-XSS-Protection: 1; mode=block
=======================================   ================

Register the middleware in the startup class:

..  code-block:: c#

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            ...

            app.UseStaticFiles();

            app.UseXXssProtection(options => options.EnabledWithBlockMode());

            app.UseMvc(...);
        }

Or as an MVC attribute, defaults to "FilterDisabled" blockMode="true":

..  code-block:: c#

    [XXssProtection]
    [XXssProtection(Policy = XXssProtectionPolicy.Disabled)]

The header is omitted for redirects and static content.