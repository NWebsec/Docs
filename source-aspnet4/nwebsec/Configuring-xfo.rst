###########################
Configuring X-Frame-Options
###########################

This header can be configured in three ways:

===================   ================
Configuration         Resulting header
===================   ================
policy="Disabled"     None
policy="Deny"         X-Frame-Options: Deny
policy="SameOrigin"   X-Frame-Options: SameOrigin
===================   ================

:doc:`NWebsec`: In web.config

..  code-block:: xml 

  <x-Frame-Options policy="Disabled"/>

:doc:`NWebsec.Owin`: Register the middleware in the OWIN startup class:

..  code-block:: c#

    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseXfo(options => options.SameOrigin());
    }

:doc:`NWebsec.Mvc`: As an MVC attribute, defaults to policy="Deny":

..  code-block:: c#
    
    [XFrameOptions]
    [XFrameOptions(Policy = XFrameOptionsPolicy.SameOrigin)]

The header is omitted for redirects.

