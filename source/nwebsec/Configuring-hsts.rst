#####################################
Configuring Strict-Transport-Security
#####################################

There are four configuration options:

* **max-age** is a ``TimeSpan`` (see `TimeSpan.Parse <http://msdn.microsoft.com/en-us/library/se73z7b9.aspx>`_)
* **includeSubdomains** adds *includeSubDomains* in the header, defaults to *false*
* **preload** adds the *preload* directive, defaults to *false*. Max-age must be at least 18 weeks, and includeSubdomains must be enabled to use the preload directive. See the `Chromium HSTS docs <http://www.chromium.org/sts>`_ for details.
* **httpsOnly** ensures that the HSTS header is set over secure connections only, defaults to *true*. 

=====================================================   =======================================================================
Configuration                                           Resulting header
=====================================================   =======================================================================
max-age="00:00:00"                                      Strict-Transport-Security: max-age=0
max-age="12:00:00"                                      Strict-Transport-Security: max-age=43200
max-age="365" includeSubdomains="true"                  Strict-Transport-Security: max-age=31536000; includeSubDomains
max-age="365" includeSubdomains="true" preload="true"   Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
=====================================================   =======================================================================

In web.config:

..  code-block:: xml
    
    <strict-Transport-Security max-age="365" />
    <strict-Transport-Security max-age="00:30:00" includeSubdomains="true" />
    <strict-Transport-Security max-age="365" includeSubdomains="true" preload="true"/>

:doc:`NWebsec.Owin`: Register the middleware in the OWIN startup class:

..  code-block:: c#

    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseHsts(options => options.MaxAge(days:30).IncludeSubdomains());
        //app.UseHsts(options => options.MaxAge(days:365).IncludeSubdomains().Preload());
    }
