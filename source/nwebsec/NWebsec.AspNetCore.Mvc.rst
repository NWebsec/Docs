NWebsec.AspNetCore.Mvc
======================

NWebsec.AspNetCore.Mvc lets you configure NWebsec through MVC ActionFilter attributes. ASP.NET Core MVC is supported. By decorating controllers and actions with attributes, the :doc:`NWebsec.AspNetCore.Middleware` configuration can be overridden. Here's the order in which the final configuration is calculated:

#. Config for Middleware
#. MVC global filter
#. MVC controller
#. MVC action

This gives a fair amount of flexibility. Do your stuff with middleware or in MVC, or both. You decide!

**************
The attributes
**************

Most elements from the :doc:`Configuration` have an MVC attribute counterpart.

Now back to the attributes — they are probably best explained in code. Here are the attributes registered as global filters in during startup for an MVC app:

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
            opts.Filters.Add(typeof(NoCacheHttpHeadersAttribute));
            opts.Filters.Add(new XRobotsTagAttribute() { NoIndex = true, NoFollow = true });
            opts.Filters.Add(typeof(XContentTypeOptionsAttribute));
            opts.Filters.Add(typeof(XDownloadOptionsAttribute));
            opts.Filters.Add(typeof(XFrameOptionsAttribute));
            opts.Filters.Add(typeof(XXssProtectionAttribute));
            //CSP
            opts.Filters.Add(typeof(CspAttribute));
            opts.Filters.Add(new CspDefaultSrcAttribute { Self = true });
            opts.Filters.Add(new CspScriptSrcAttribute { Self = true });
            //CSPReportOnly
            opts.Filters.Add(typeof(CspReportOnlyAttribute));
            opts.Filters.Add(new CspScriptSrcReportOnlyAttribute { None = true });
        });
    }

Here's what the attributes will look like when applied to a controller and an action method:

..  code-block:: c#

    using Microsoft.AspNetCore.Mvc;
    using NWebsec.AspNetCore.Mvc;

    ...

    [NoCacheHttpHeaders]
    [XContentTypeOptions]
    [XDownloadOptions]
    [XFrameOptions(Policy = XFrameOptionsPolicy.SameOrigin)]
    [XXssProtection]
    public class HomeController : Controller
    {
        [XFrameOptions(Policy = XFrameOptionsPolicy.Deny)]
        public IActionResult Index()
        {
            return View();
        }

        [NoCacheHttpHeaders(Enabled = false)]
        [XContentTypeOptions(Enabled = false)]
        [XDownloadOptions(Enabled = false)]
        [XFrameOptions(Policy = XFrameOptionsPolicy.Disabled)]
        [XXssProtection(Policy = XXssProtectionPolicy.Disabled)]
        [XRobotsTag(Enabled = false)]
        public IActionResult HeadersDisabled()
        {
            ViewData["Message"] = "Your application description page.";

            return View("About");
        }
    }

Note how the Index action method is decorated with only one attribute. It has its own XFrameOptions setting, and will inherit all other attributes from the controller.

The HeadersDisabled action shows how headers can be disabled per action or controller. This lets you define a strict global security policy for your application and relax the policy where needed. 
