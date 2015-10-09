###########################
Configuring Public-Key-Pins
###########################

There are four configuration options, as well as a list of certs to pin and/or a list of pin values. Note that you must supply two pins to generate a valid header, i.e. two certs, a cert and a pin value, or two pin values.

* **max-age** is a ``TimeSpan`` (see `TimeSpan.Parse <http://msdn.microsoft.com/en-us/library/se73z7b9.aspx>`_)
* **includeSubdomains** adds *includeSubDomains* in the header, defaults to *false*
* **httpsOnly** ensures that the HSTS header is set over secure connections only, defaults to *true*. 
* **reportUri** specifies an absolute URI to where the browser can report HPKP violations. The scheme must be HTTP or HTTPS. 
* **certificates** specifies a list of certificates (by thumbprints) that should be pinned. 
* **pins** specifies a list of pinning values for certificates that should be pinned

The following examples assume that we supply the pinning values: 

* n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE=
* d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=

.. |br| raw:: html

   <br />

========================================================================================  ==============================================================================
Configuration                                                                             Resulting header
========================================================================================  ==============================================================================
max-age="00:00:00"                                                                        Public-Key-Pins: max-age=0
max-age="12:00:00"                                                                        Public-Key-Pins: max-age=43200;pin-sha256="n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE=";pin-sha256="d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM="
max-age="365" |br| includeSubdomains="true"                                               Public-Key-Pins: max-age=31536000;includeSubdomains;pin-sha256="n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE=";pin-sha256="d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM="
max-age="365" |br| includeSubdomains="true" |br| report-uri="https://report.nwebsec.com/  Public-Key-Pins: max-age=31536000;includeSubdomains;pin-sha256="n3dNcH43TClpDuyYl55EwbTTAuj4T7IloK4GNaH1bnE=";pin-sha256="d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=";report-uri="https://report.nwebsec.com/" |
========================================================================================  ==============================================================================

In web.config:

..  code-block:: xml

    <public-Key-Pins max-age="30" includeSubdomains="true">
      <certificates>
        <add thumbprint="FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF"/>
      </certificates>
      <pins>
        <add pin="Base64 pin"/>
      </pins>
    </public-Key-Pins>
    <public-Key-Pins-Report-Only max-age="00:00:10"  report-uri="https://report.nwebsec.com/">
      <certificates>
        <add thumbprint="00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" />
        <add thumbprint="01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01" />
      </certificates>
    </public-Key-Pins-Report-Only>

:doc:`NWebsec.Owin`: Register the middleware in the OWIN startup class:

..  code-block:: c#

    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseHpkp(options => options
            .MaxAge(seconds: 20)
            .Sha256Pins("d6qzRu9zOECb90Uez27xWltNsj0e1Md7GkYYkVoZWmM=")
            .PinCertificate("FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF")
            .ReportUri("https://nwebsec.com/report")
            );
    }
