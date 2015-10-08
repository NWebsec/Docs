########################
Configuring X-Robots-Tag
########################

You might be familiar with the Robots Exclusion Protocol (REP), often communicated by a robots.txt file on the root of a site or through meta tags in HTML such as:

..  code-block:: html
    
    <meta name="robots" content="noindex, nofollow">

REP gives some control over which content search engines will index on your site, i.e. for search engines who respect REP. Remember, you are politely asking search engines to not index your content — but not all search engines are that polite.

In addition to `robots.txt <http://www.robotstxt.org/>`_ and meta tags, some of the major search engines support REP through an HTTP header. The following header is the equivalent to the aforementioned meta tag:

..

  X-Robots-Tag: noindex, nofollow

Using the HTTP header can be a nice alternative to the robots.txt and the meta tags — especially for content other than html such as PDF, XML or Office files. The header is supported by Bing and Google, refer to these two resources for the nitty gritty details:

* `Prevent a bot from getting "lost in space" <http://www.bing.com/community/site_blogs/b/webmaster/archive/2009/08/21/prevent-a-bot-from-getting-lost-in-space-sem-101.aspx>`_
* `Robots meta tag and X-Robots-Tag HTTP header specifications <https://developers.google.com/webmasters/control-crawl-index/docs/robots_meta_tag>`_

NWebsec lets you emit the X-Robots-Tag header as of version 2.1.0.  The directives supported are:

* **noindex** - Instructs search engines to not index the page
* **nofollow** - Instructs search engines to not follow links on the page
* **nosnippet** - Instructs search engines to not display a snippet for the page in search results
* **noarchive** - Instructs search engines to not offer a cached version of the page in search results
* **noodp** - Instructs search engines to not use information from the Open Directory Project for the page's title or snippet
* **notranslate** - Instructs search engines to not offer translation of the page in search results (Google only)
* **noimageindex** - Instructs search engines to not index images on the page (Google only)

There are several ways to enable the X-Robots-Tag header:

With :doc:`NWebsec` you can enable it in web.config (*enabled* and at least one directive must be true):

..  code-block:: xml
    
    <nwebsec>
        <httpHeaderSecurityModule>
            <x-Robots-Tag enabled="true"
                           noIndex="true"
                           noFollow="false"
                           noArchive="false"
                           noOdp="false"
                           noSnippet="false"
                           noImageIndex="false"
                           noTranslate="false"/>
        </httpHeaderSecurityModule>
    </nwebsec>

With :doc:`NWebsec.Owin`, you register the middleware in the OWIN startup class:

..  code-block:: c#
    
    using NWebsec.Owin;
    ...
    public void Configuration(IAppBuilder app)
    {
        app.UseXRobotsTag(options => options.NoIndex().NoFollow());
    }

:doc:`NWebsec.Mvc` lets you register an MVC filter:

..  code-block:: c#

    public static void RegisterGlobalFilters(GlobalFilterCollection filters)
    {
        filters.Add(new XRobotsTagAttribute() { NoIndex = true, NoFollow = true });
    }

You can also set the attribute on controllers and actions, see :doc:`NWebsec.Mvc` for details.