###################################
Configuring Content-Security-Policy
###################################

Consult :doc:`Breaking-changes` if you're upgrading to the NWebsec 4.x packages.

Content-Security-Policy (CSP) provides a safety net for injection attacks by specifying a whitelist from where various content in a webpage can be loaded from.

If you're unfamiliar with CSP you should read `An Introduction to Content Security Policy <https://www.html5rocks.com/en/tutorials/security/content-security-policy/>`_ by Mike West, one of the Chrome developers. You'll also find information about CSP on the `Mozilla Developer Network <https://developer.mozilla.org/en-US/docs/Security/CSP>`_.
 
At the time of writing, CSP 1.0 is supported by most major browsers (Opera/Chrome/Firefox/Safari/Edge).

Chrome/Opera and Firefox are the first browsers to implement support CSP Level 2.

A page's content security policy is set through the following headers:

* **Content-Security-Policy**
* **Content-Security-Policy-Report-Only**

**********************
CSP support in NWebsec
**********************

NWebsec emits the **Content-Security-Policy** header, but no longer supports the deprecated **X-Content-Security-Policy** and/or **X-WebKit-CSP** headers. 

You should read this entire article to understand how CSP configuration is inherited and/or overridden in NWebsec. We'll start with a general introduction, and then move on to the configuration section and the MVC attributes.

*****************
CSP configuration
*****************

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

CSP 2 also introduces script and style hashes and nonces. You'll find a good write-up on this on the `Mozilla blog <https://blog.mozilla.org/security/2014/10/04/csp-for-the-web-we-have/>`_. NWebsec supports script and style nonces as of version 3.2.0.

`CSP level 3 <https://www.w3.org/TR/CSP3/>`_ adds quite a few new directives over these, currently supported by NWebsec are:

* manifest-src
* block-all-mixed-content 

`Upgrade Insecure Requests <http://www.w3.org/TR/upgrade-insecure-requests/>`_ adds another CSP directive, see :doc:`Upgrade-insecure-requests` for details.

To use a directive, it must be configured with at least one source. The standard specifies some special sources.

* 'none' — No content of this type is allowed

  * Supported by all directives

* 'self' — Content of this type can only be loaded from the same origin (no content from other sites)

  * Supported by all directives
* 'unsafe-inline' — Allows unsafe inline content.

  * Supported by style-src (inline css) and script-src (inline script)
* 'unsafe-eval' — Allows script functions considered unsafe (such as eval())

  * Supported by script-src

You can also specify your own sources, in various formats specified by the [url:standard|http://www.w3.org/TR/CSP/#source-list]. Here are a few examples.

* \* — Allow content from anywhere
* https: — Scheme only, load only content served over https
* \*.nwebsec.com — Wildcard host, allow content from any nwebsec.com sub-domain.
* www.nwebsec.com:81 — You can specify a port number
* https://www.nwebsec.com — You can of specify an absolute URI for a host (path has no effect though)

NWebsec validates the configured sources and will let you know if something is wrong.

CSP 2 specifies support for internationalized domain names in custom sources.

The built-in report handler
===========================

If you configure the report-uri directive, the browser will report CSP violations to that URI (as JSON). The CSP standard includes an example of a `CSP violation report <http://www.w3.org/TR/CSP/#sample-violation-report>`_. Note that some browsers will submit the violation report without cookies when reporting same-origin. You might need to poke a hole in your authorization rules if you rely on authentication cookies to get the requests through.

NWebsec 2.0.0 introduced a built-in CSP report handler, so you don't need to implement your own. It will pick up the report before the ASP.NET authorization event fires, so you don't need to poke a whole in the authorization rules.

When a CSP report is received, NWebsec raises an event. You can handle these events by adding the following code to global.asax

..  code-block:: c#

    protected void NWebsecHttpHeaderSecurityModule_CspViolationReported(object sender, CspViolationReportEventArgs e)
    {
        var report = e.ViolationReport;
    }

You'd probably want to log the violation to keep track of what's going on in your web application.

Report-Only mode
================

The CSP standard actually defines two headers: Content-Security-Policy and Content-Security-Policy-Report-Only. Browsers will enforce the CSP when they see the first header, i.e. they will not load content that violates the policy and report the violation. If you use the Report-Only header, CSP will not be enforced by the browser, so all content will be loaded but violations will still be reported.

NWebsec lets you configure these headers independently so you can use one or the other, or both.

**********************************
Configuring CSP through web.config
**********************************

You need to enable CSP, here's the relevant configuration line from the NWebsec [[Configuration]]: 

..  code-block:: xml

    <content-Security-Policy enabled="true">

To use the report only header, you can use:

..  code-block:: xml

    <content-Security-Policy-Report-Only enabled="true">

You configure directives like you do for ``<content-Security-Policy>``.

Directives in web.config
========================

CSP defines a list of directives, where each directive has a list with one or more source definitions, the configuration example includes common directives:

..  code-block:: xml

    <content-Security-Policy enabled="true">
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
      <report-uri enableBuiltinHandler="true"/>
    </content-Security-Policy>

This config would give you the header:

..

  Content-Security-Policy: default-src 'self'; script-src 'self' nwebsec.codeplex.com scripts.nwebsec.com; object-src 'none'; style-src 'self'; img-src 'self' images.nwebsec.com; media-src 'none'; frame-src 'none'; font-src 'none'; connect-src 'none'; frame-ancestors 'none'; report-uri /WebResource.axd?cspReport=true

Sources in web.config
=====================

Each directive can have one or more sources. The special CSP sources are configured through attributes, while custom sources are added to a source collection. Here's an example where the script-src directive is configured with the special 'self' source, and two custom sources:

..  code-block:: xml

    <script-src self="true">
      <add source="nwebsec.codeplex.com" />
      <add source="scripts.nwebsec.com" />
    </script-src>

Here's an example where the special sources 'unsafe-eval' and 'unsafe-inline' are enabled for the script-src directive (use with caution, this will effectively disable the XSS protection):

..  code-block:: xml

    <script-src unsafeEval="true" unsafeInline="true" />

Configuring CSP middleware
==========================

The :doc:`NWebsec.Owin` package includes CSP middleware. Here's an example of how you register the middleware in the OWIN startup class:

..  code-block:: c#

    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseCsp(options => options
            .DefaultSources(s => s.Self())
            .ScriptSources(s => s.Self().CustomSources("scripts.nwebsec.com"))
            .ReportUris(r => r.Uris("/report")));

            app.UseCspReportOnly(options => options
                .DefaultSources(s => s.Self())
                .ImageSources(s => s.None()));
    	}

*******************************************
Script and style nonces through HtmlHelpers
*******************************************

The :doc:`NWebsec.Mvc` package includes HtmlHelpers to add CSP 2 script and style nonces to allow inline scripts/styles. The helpers will output the complete nonce-attribute. Here is an example of usage:

..  code-block:: html

    <script @Html.CspScriptNonce()>document.write("Hello world")</script>
    <style @Html.CspStyleNonce()>
       h1 {
              font-size: 10em;
            }
    </style>

**************************************
Configuring CSP through MVC attributes
**************************************

The :doc:`NWebsec.Mvc` package provides MVC attributes to configure the security headers. The CSP policy defined by the MVC attributes are overridden per directive, this aligns with how this works in the web.config. That means that you define your baseline policy in web.config, CSP middleware or through global filters, and you can easily override a particular directive on a controller or action.

Here's an example. You can e.g. enable CSP, and register a directive as global filters:

..  code-block:: c#

    public static void RegisterGlobalFilters(GlobalFilterCollection filters)
    {
        filters.Add(new CspAttribute());
        filters.Add(new CspDefaultSrcAttribute { Self = true });
    }

And consider the following controller:

..  code-block:: c#

    [CspScriptSrc(Self = true, CustomSources = "scripts.nwebsec.codeplex.com")]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View("Index");
        }

        [CspDefaultSrc(CustomSources = "nwebsec.codeplex.com")]
        public ActionResult Index2()
        {
            return View("Index");
        }

        [CspDefaultSrc(CustomSources = "stuff.nwebsec.codeplex.com")]
        [CspScriptSrc(CustomSources = "scripts.nwebsec.codeplex.com ajax.googleapis.com")]
        public ActionResult Index3()
        {
            return View("Index");
        }
    }

The index action will inherit the global attribute as well as the attribute set on the controller, which yields this header:

::  

  Content-Security-Policy: default-src 'self'; script-src 'self' scripts.nwebsec.codeplex.com

The index2 action inherits previous directives yielding:

::

  Content-Security-Policy: default-src 'self' nwebsec.codeplex.com; script-src 'self' scripts.nwebsec.codeplex.com

The index3 action also inherits all directives, thus giving us this header:
::

  Content-Security-Policy: default-src 'self' stuff.nwebsec.codeplex.com; script-src 'self' scripts.nwebsec.codeplex.com scripts.nwebsec.com ajax.googleapis.com

To have a directive completely removed, disable it as such:

..  code-block:: c#

    [CspScriptSrc(Enabled = false)]

You can also disable CSP altogether:

..  code-block:: c#

    [Csp(Enabled = false)]
