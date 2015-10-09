Getting started with NWebsec
============================
NWebsec lets you configure quite a few security headers, some are useful for most applications while others are a bit more specialized. Here's some guidance to get you started.

First, you need to add NWebsec to your application. The easiest way to do this would be to get it through NuGet. Search for *NWebsec* in the package manager GUI, or install it through the console with one of the following commands:

For an MVC3/4/5 app:

..  code-block:: powershell

    Install-Package NWebsec.Mvc

For non-MVC apps use the following:

..  code-block:: powershell

    Install-Package NWebsec

Alternatively, you can get the latest version of the assemblies under `releases <https://github.com/NWebsec/NWebsec/releases>`_ if you want to add them by hand. In that case, refer to :doc:`Configuration` to also edit the configuration by hand. 

Now it's time to start securing your application! It's good practice to remove the version headers added by ASP.NET and IIS, so you'd want to *suppress version headers* for your web application. The NuGet installation procedure will make some modifications to the web.config to disable version headers.

To avoid various attacks carried out through iframes, the *X-Frame-Options header* should be enabled. MIME sniffing is a source to many problems, including security issues, so you'd want to run with the *X-Content-Type-Options header*.

For applications that run over SSL/TLS, you should most definitely employ the *Strict-Transport-Security header* — instructing the browser to interact with anything on your domain over a secured connection only.

Unless your application needs to redirect users to arbitrary sites on the internet, you'd want *redirect validation* enabled. There might be a few sites you'd want to whitelist for redirects, in particular if you use WIF or Google/Facebook/any other external authentication provider. Consult :doc:`Redirect-validation` if you run into trouble.

So, for an application running over http the following is a reasonable starting point for your web.config:

..  code-block:: xml

    <configuration>
    ...
      <nwebsec>
        <httpHeaderSecurityModule xmlns="http://nwebsec.com/HttpHeaderSecurityModuleConfig.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="NWebsecConfig/HttpHeaderSecurityModuleConfig.xsd">
          <redirectValidation enabled="true" />
          <securityHttpHeaders>
            <x-Frame-Options policy="Deny"/>
            <x-Content-Type-Options enabled="true" />
          </securityHttpHeaders>
        </httpHeaderSecurityModule>
      </nwebsec>
    ...
    </configuration>

If your site is served over https, you'd also want to include the Strict-Transport-Security header, as such (note that the browser will load all content over https for the entire domain when the header is used):

..  code-block:: xml

    <configuration>
    ...
      <nwebsec>
        <httpHeaderSecurityModule xmlns="http://nwebsec.com/HttpHeaderSecurityModuleConfig.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="NWebsecConfig/HttpHeaderSecurityModuleConfig.xsd">
          <redirectValidation enabled="true" />
          <securityHttpHeaders>
            <x-Frame-Options policy="Deny"/>
            <strict-Transport-Security max-age="365" />
            <x-Content-Type-Options enabled="true" />
          </securityHttpHeaders>
        </httpHeaderSecurityModule>
      </nwebsec>
    ...
    </configuration>

**Note!** If users can log into you application, you should always run it over https to keep your users safe!

NWebsec lets you add other security headers as well, but these are more tightly coupled to the individual resources in your application. In particular, the *Content-Security-Policy (CSP) header* can significantly improve the security of a web application but also requires great care when you're building a new application from the ground up — even more so if you retrofit it onto an existing application. SendSafely has published two blog posts discussing how they dealt with the challenge, links included for the interested reader:

* `Using Content Security Policy to Prevent Cross-Site Scripting (XSS) <http://blog.sendsafely.com/post/42277333593/using-content-security-policy-to-prevent-cross-site>`_
* `Retrofitting Code for Content Security Policy <http://blog.sendsafely.com/post/50303516209/retrofitting-code-for-content-security-policy>`_

See :doc:`Configuring-csp` to learn how to enable CSP, this is where the real job starts. Good luck! :)

Note also that security headers can be enabled through MVC attributes, refer to :doc:`NWebsec.Mvc` for details.
