##############################
Configuring X-Download-Options
##############################

There are two settings:

===============   ================
Configuration     Resulting header
===============   ================
enabled="false"   None
enabled="true"    X-Download-Options: noopen
===============   ================

In web.config:

..  code-block:: xml

    <x-Download-Options enabled="false"/>

:doc:`NWebsec.Owin`: Register the middleware in the OWIN startup class:

..  code-block:: c#

    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseXDownloadOptions();
    }

Or as an MVC attribute (which defaults to true):

..  code-block:: c#

    [XDownloadOptions]
    [XDownloadOptions(Enabled = false)]

The header is omitted for redirects.
