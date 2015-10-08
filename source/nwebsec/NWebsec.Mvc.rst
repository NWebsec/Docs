###########
NWebsec.Mvc
###########

NWebsec.Mvc lets you configure the [[HttpHeaderModule]] through MVC ActionFilter attributes. MVC 3 or newer is supported. By decorating controllers and actions with attributes, the HttpHeaderModule's [[Configuration]] is overridden. This is how it works:

NWebsec.Mvc depends on the NWebsec package, which includes the HttpHeaderModule. This module relies on its [[Configuration]], if there is any. Now, the attributes in NWebsec.Mvc lets you override the HttpHeaderModule's configuration, here's the order in which the final configuration is calculated:

#. Web.config
#. MVC global filter
#. MVC controller
#. MVC action

This gives a fair amount of flexibility. Do your stuff in config or in MVC, or both. You decide!

**************
The attributes
**************

Most elements from the [[Configuration]] have an MVC attribute counterpart, see [[Configuring security headers]] to learn what their settings are.

The Content Security Policy attributes are a bit special, see [[Configuring Content Security Policy]] for details. 

Now back to the attributes — they are probably best explained in code. Here are the attributes registered as global filters in Global.asax in a typical MVC app:

..  code-block:: c#

    using System.Web.Mvc;
    using NWebsec.Csp;
    using NWebsec.Mvc.HttpHeaders;
    using NWebsec.Mvc.HttpHeaders.Csp;

    ....

    public static void RegisterGlobalFilters(GlobalFilterCollection filters)
    {
        filters.Add(new SetNoCacheHttpHeadersAttribute());
        filters.Add(new XRobotsTagAttribute() { NoIndex = true, NoFollow = true });
        filters.Add(new XContentTypeOptionsAttribute());
        filters.Add(new XDownloadOptionsAttribute());
        filters.Add(new XFrameOptionsAttribute());
        filters.Add(new XXssProtectionAttribute());
        //CSP
        filters.Add(new CspAttribute());
        filters.Add(new CspDefaultSrcAttribute { Self = Source.Enable });
        filters.Add(new CspScriptSrcAttribute { Self = Source.Enable });
        //CSPReportOnly
        filters.Add(new CspReportOnlyAttribute());
        filters.Add(new CspScriptSrcReportOnlyAttribute { None = Source.Enable });
    }

Here's what the attributes will look like when applied to a controller and an action method:

..  code-block:: c#

    using System.Web.Mvc;
    using NWebsec.HttpHeaders;
    using NWebsec.Mvc.HttpHeaders;

    ...

    [SetNoCacheHttpHeaders]
    [XContentTypeOptions]
    [XDownloadOptions]
    [XFrameOptions(Policy = XFrameOptionsPolicy.SameOrigin)]
    [XXssProtection]
    public class HomeController : Controller
    {

        [XFrameOptions(Policy = XFrameOptionsPolicy.Deny)]
        public ActionResult Index()
        {
            return View();
        }


        [SetNoCacheHttpHeaders(Enabled = false)]
        [XContentTypeOptions(Enabled = false)]
        [XDownloadOptions(Enabled = false)]
        [XFrameOptions(Policy = XFrameOptionsPolicy.Disabled)]
        [XXssProtection(Policy = XXssProtectionPolicy.Disabled)]
        [XRobotsTag(Enabled = false)]
        public ActionResult HeadersDisabled()
        {
            return View();
        }
    }

Note how the Index action method is decorated with only one attribute. It has its own XFrameOptions setting, and will inherit all other attributes from the controller.

The HeadersDisabled action shows how headers can be disabled per action or controller. This lets you define a strict global security policy for your application and relax the policy where needed. 
