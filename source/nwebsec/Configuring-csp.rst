Configuring Content-Security-Policy
===================================

Content-Security-Policy (CSP) provides a safety net for injection attacks by specifying a whitelist from where various content in a webpage can be loaded from.

If you're unfamiliar with CSP you should read `An Introduction to Content Security Policy <https://www.html5rocks.com/en/tutorials/security/content-security-policy/>`_ by Mike West, one of the Chrome developers. You'll also find information about CSP on the `Mozilla Developer Network <https://developer.mozilla.org/en-US/docs/Security/CSP>`_.
 
A page's content security policy is set through the following headers:

* **Content-Security-Policy**
* **Content-Security-Policy-Report-Only**

CSP support in NWebsec
----------------------

You should read this entire article to understand how CSP configuration is inherited and/or overridden in NWebsec. We'll start with a general introduction, and then move on to the configuration section and the MVC attributes.

CSP configuration
-----------------

NWebsec emits the CSP header if CSP is enabled and one or more directives are configured — except for redirects and static content. The directives specified in `CSP 1.0 <https://www.w3.org/TR/CSP/>`_ are:

* default-src — Specifies the default for other sources
* script-src
* style-src
* object-src
* img-src
* media-src
* frame-src
* font-src
* connect-src
* sandbox (optional to implement)
* report-uri — Specifies where CSP violations can be reported

`CSP level 2 <https://www.w3.org/TR/CSP2/>`_ adds quite a few new directives over these, currently supported by NWebsec are:

* frame-ancestors
* base-uri
* child-src
* form-action
* sandbox (no longer optional)

CSP 2 also introduces script and style hashes and nonces. You'll find a good write-up on this on the `Mozilla blog <https://blog.mozilla.org/security/2014/10/04/csp-for-the-web-we-have/>`_.

`CSP level 3 <https://www.w3.org/TR/CSP3/>`_ adds quite a few new directives over these, currently supported by NWebsec are:

* manifest-src
* block-all-mixed-content
* strict-dynamic

`Upgrade Insecure Requests <https://www.w3.org/TR/upgrade-insecure-requests/>`_ adds another CSP directive, see :doc:`Upgrade-insecure-requests` for details.

To use a directive, it must be configured with at least one source. The standard specifies some special sources.

* 'none' — No content of this type is allowed

  * Supported by all directives

* 'self' — Content of this type can only be loaded from the same origin (no content from other sites)

  * Supported by all directives
* 'unsafe-inline' — Allows unsafe inline content.

  * Supported by style-src (inline css) and script-src (inline script)
* 'unsafe-eval' — Allows script functions considered unsafe (such as eval())

  * Supported by script-src

You can also specify your own sources, in various formats specified by the `standard <https://www.w3.org/TR/CSP2/#source-list-syntax>`_. Here are a few examples.

* \* — Allow content from anywhere
* https: — Scheme only, load only content served over https
* \*.nwebsec.com — Wildcard host, allow content from any nwebsec.com sub-domain.
* www.nwebsec.com:81 — You can specify a port number
* https://www.nwebsec.com — You can of specify an absolute URI for a host (path has no effect though)

NWebsec validates the configured sources and will let you know if something is wrong.

CSP 2 specifies support for internationalized domain names in custom sources.

Report-Only mode
----------------

The CSP standard actually defines two headers: Content-Security-Policy and Content-Security-Policy-Report-Only. Browsers will enforce the CSP when they see the first header, i.e. they will not load content that violates the policy and report the violation. If you use the Report-Only header, CSP will not be enforced by the browser, so all content will be loaded but violations will still be reported.

NWebsec lets you configure these headers independently so you can use one or the other, or both.

Configuring CSP middleware
--------------------------

The :doc:`NWebsec.AspNetCore.Middleware` package includes CSP middleware. Here's an example of how you register the middleware in the OWIN startup class:

..  code-block:: c#

    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseCsp(options => options
            .DefaultSources(s => s.Self())
            .ScriptSources(s => s.Self().CustomSources("scripts.nwebsec.com", "*.some-cdn.com"))
            .ReportUris(r => r.Uris("/report")));

            app.UseCspReportOnly(options => options
                .DefaultSources(s => s.Self())
                .ImageSources(s => s.None()));
    	}

Script and style nonces through tag helpers
-------------------------------------------

The :doc:`NWebsec.AspNetCore.Mvc.TagHelpers` package includes Tag helpers to add CSP 2 script and style nonces to allow inline scripts/styles. The helpers will output the complete nonce-attribute. Here is an example of usage:

..  code-block:: html

    <script nws-csp-add-nonce="true">document.write("Hello world")</script>
    <style nws-csp-add-nonce="true">
       h1 {
              font-size: 10em;
            }
    </style>

Configuring CSP through MVC attributes
--------------------------------------

The :doc:`NWebsec.AspNetCore.Mvc` package provides MVC attributes to configure the security headers. The CSP policy defined by the MVC attributes are overridden per directive, this aligns with how this works in the web.config. That means that you define your baseline policy in web.config, CSP middleware or through global filters, and you can easily override a particular directive on a controller or action.

Here's an example. You can e.g. enable CSP, and register directives through global filters:

..  code-block:: c#

    ...
    using NWebsec.AspNetCore.Mvc;
    using NWebsec.AspNetCore.Mvc.Csp;

    ....

    public void ConfigureServices(IServiceCollection services)
    {
        // Add framework services.
        services.AddMvc(opts =>
        {
            opts.Filters.Add(typeof(CspAttribute));
            opts.Filters.Add(new CspDefaultSrcAttribute { Self = true });

            //CSPReportOnly
            //opts.Filters.Add(typeof(CspReportOnlyAttribute));
            //opts.Filters.Add(new CspScriptSrcReportOnlyAttribute { None = true });
        });
    }

And consider the following controller:

..  code-block:: c#

    [CspScriptSrc(Self = true, CustomSources = "scripts.nwebsec.com")]
    public class HomeController : Controller    

    {
        public IActionResult Index()
        {
            return View();
        }

        [CspDefaultSrc(CustomSources = "nwebsec.com")]
        public IActionResult Index2()
        {
            return View();
        }

        [CspDefaultSrc(CustomSources = "stuff.nwebsec.com")]
        [CspScriptSrc(CustomSources = "scripts.nwebsec.com ajax.googleapis.com")]
        public IActionResult Index3()
        {
            return View();
        }
    }

The index action will inherit the global attribute as well as the attribute set on the controller, which yields this header:

::  

  Content-Security-Policy: default-src 'self'; script-src 'self' scripts.nwebsec.com

The index2 action inherits previous directives yielding:

::

  Content-Security-Policy: default-src 'self' nwebsec.com; script-src 'self' scripts.nwebsec.com

The index3 action also inherits all directives, thus giving us this header:

::

  Content-Security-Policy: default-src 'self' stuff.nwebsec.com; script-src 'self' scripts.nwebsec.com ajax.googleapis.com

To have a directive completely removed, disable it as such:

..  code-block:: c#

    [CspScriptSrc(Enabled = false)]

You can also disable CSP altogether:

..  code-block:: c#

    [Csp(Enabled = false)]
