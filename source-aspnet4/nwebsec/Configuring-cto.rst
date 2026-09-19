##################################
Configuring X-Content-Type-Options
##################################

There are two settings:

===============  ================
Configuration    Resulting header
===============  ================
enabled="false"  None
enabled="true"   X-Content-Type-Options: nosniff
===============  ================

In web.config:

..  code-block:: xml

    <x-Content-Type-Options enabled="false"/>

:doc:`NWebsec.Owin`: Register the middleware in the OWIN startup class:


..  code-block:: c#

    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseXContentTypeOptions();
    }

Or as an MVC attribute (which defaults to true):

..  code-block:: c#

  [XContentTypeOptions]
  [XContentTypeOptions(Enabled = false)]

The header is omitted for redirects.
