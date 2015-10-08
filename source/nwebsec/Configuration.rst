#############
Configuration
#############

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   Cache headers <Configuring-cache-headers>
   Redirect validation <Redirect-validation>
   Content-Security-Policy <Configuring-csp>
   Strict-Transport-Security <Configuring-hsts>
   Public-Key-Pins <Configuring-hpkp>
   X-Frame-Options <Configuring-xfo>
   X-Xss-Protection <Configuring-xxss>
   X-Content-Type-Options <Configuring-cto>
   X-Download-Options <Configuring-xdo>
   X-Robots-Tag <Configuring-xrt>
   Suppressing-version-headers

This is the documentation for NWebsec 4.x web.config.

Those running an older versions should consult [[Breaking changes]] before upgrading major versions and can find old versions of this document here: [[Configuration 3.x]].

You're strongly advised to upgrade if you're still running NWebsec 2.x, as you can run into issues with async requests due to changes in ASP.NET.

## Web.config

Only the most basic configuration is added to web.config when installing the NWebsec library with the NuGet package manager. Here's an example of what's added to web.config:

..  code-block:: xml

  <configuration>
    <configSections>
      <sectionGroup name="nwebsec">
        <section name="httpHeaderSecurityModule" type="NWebsec.Modules.Configuration.HttpHeaderSecurityConfigurationSection, NWebsec, Version=4.1.0.0, Culture=neutral, PublicKeyToken=3613da5f958908a1" requirePermission="false" />
      </sectionGroup>
    </configSections>

    <system.web>
      <httpRuntime enableVersionHeader="false"/>
    </system.web>
    <system.webServer>
      <modules>
        <add name="NWebsecHttpHeaderSecurityModule" type="NWebsec.Modules.HttpHeaderSecurityModule, NWebsec, Version=4.1.0.0, Culture=neutral, PublicKeyToken=3613da5f958908a1" />
      </modules>
      <httpProtocol>
        <customHeaders>
          <clear />
        </customHeaders>
      </httpProtocol>
      <security>
        <requestFiltering>
          <hiddenSegments>
            <add segment="NWebsecConfig" />
          </hiddenSegments>
        </requestFiltering>
      </security>
    </system.webServer>
    <nwebsec>
      <httpHeaderSecurityModule xmlns="http://nwebsec.com/HttpHeaderSecurityModuleConfig.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="NWebsecConfig/HttpHeaderSecurityModuleConfig.xsd">

      </httpHeaderSecurityModule>
    </nwebsec>
  </configuration>

The NWebsec config section is declared, the module is loaded, custom http headers will be cleared, the NWebsec configuration directory is declared as a hidden segment, and an empty NWebsec configuration section is added.

You'll probably notice that configuration is also added to the `<system.webserver>` section in order to load the NWebsec _httpHeaderModule_ . If you're running on IIS 6 or in Classic Pipeline Mode you will have to do some manual changes to your web.config to load the module, see [IIS 6 or IIS 7 Classic Pipeline Mode
](#iis-6-or-iis-7-classic-pipeline-mode).

The configuration schema gives you intellisense for all NWebsec configuration elements, so feel free to start of with the empty section and add the security headers you need.

For the curious, here's a complete configuration section with all headers disabled:

..  code-block:: xml

  <configuration>

    <nwebsec>
      <httpHeaderSecurityModule xmlns="http://nwebsec.com/HttpHeaderSecurityModuleConfig.xsd" 
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                                xsi:noNamespaceSchemaLocation="NWebsecConfig/HttpHeaderSecurityModuleConfig.xsd">
        <redirectValidation enabled="false">
          <allowSameHostRedirectsToHttps enabled="false" httpsPorts="8443,443"/>
          <add allowedDestination="http://www.nwebsec.com/"/>
        </redirectValidation>
        <setNoCacheHttpHeaders enabled="false" />
        <x-Robots-Tag enabled="false"
                      noIndex="false"
                      noFollow="false"
                      noArchive="false"
                      noOdp="false"
                      noSnippet="false"
                      noImageIndex="false"
                      noTranslate="false"/>
        <securityHttpHeaders>
          <x-Frame-Options policy="Disabled"/>
          <strict-Transport-Security max-age="00:00:00"
                                     includeSubdomains="true"
                                     httpsOnly="true"
                                     preload="false" />
          <!--<public-Key-Pins max-age="00:00:10">
            <certificates>
              <add thumbprint="cert thumbprint" storeName="Root" />
            </certificates>
            <pins>
              <add pin="Base64 pin"/>
            </pins>
          </public-Key-Pins>-->
          <x-Content-Type-Options enabled="false" />
          <x-Download-Options enabled="false" />
          <x-XSS-Protection policy="Disabled" blockMode="true" />
          <content-Security-Policy enabled="false">
            <default-src self="true"/>
            <script-src self="true">
              <add source="nwebsec.codeplex.com" />
              <add source="scripts.nwebsec.com" />
            </script-src>
            <style-src unsafeInline="false" self="true" />
            <img-src self="true">
              <add source="images.nwebsec.com"/>
            </img-src>
            <object-src none="true" />
            <media-src none="true" />
            <frame-src none="true" />
            <font-src none="true" />
            <connect-src none="true" />
            <frame-ancestors none="true" />
            <base-uri self="true"/>
            <child-src self="true"/>
            <form-action self="true"/>
            <sandbox enabled="true"/>
            <plugin-types>
              <add media-type="application/pdf"/>
            </plugin-types>
            <report-uri enableBuiltinHandler="true"/>
          </content-Security-Policy>
          <!-- This section works exactly like "x-Content-Security-Policy", but will output report-only headers instead. -->
          <content-Security-Policy-Report-Only enabled="false">
            <default-src self="true" />
            <script-src unsafeEval="true" unsafeInline="true" />
            <report-uri>
              <add report-uri="/cspreporthandler" />
            </report-uri>
          </content-Security-Policy-Report-Only>
        </securityHttpHeaders>
      </httpHeaderSecurityModule>
    </nwebsec>

  </configuration>

************************************
IIS 6 or IIS 7 Classic Pipeline Mode
************************************

If your application is running in Classic Pipeline Mode (as opposed to [Integrated Pipeline Mode](http://learn.iis.net/page.aspx/243/aspnet-integration-with-iis/)), you'll have to add configuration by hand to load the HttpHeaderModule, here's an example:

..  code-block:: xml

  <system.web>
    <httpModules>
      <add name="NWebsecHttpHeaderSecurityModule" type="NWebsec.Modules.HttpHeaderSecurityModule, NWebsec, Version=4.1.0.0, Culture=neutral, PublicKeyToken=3613da5f958908a1" />
    </httpModules>
  </system.web>

You should also consider removing the ``<system.webServer>`` section if that did not exist before it was added by the NuGet installer.