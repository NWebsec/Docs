# Redirect validation
If you're familiar with the [OWASP top ten list](https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project) you'll know that _Unvalidated Redirects and Forwards_ has been lingering as number ten on that list the last couple of years. These types of vulnerabilities are used in real attacks but fortunately there are several ways to deal with them. You'll find a nice write-up on the issues and potential countermeasures here: [OWASP Top 10 for .NET developers part 10: Unvalidated Redirects and Forwards](http://www.troyhunt.com/2011/12/owasp-top-10-for-net-developers-part-10.html).

The proper remedy for unvalidated redirects lie in the code. Whenever an application redirects the user based on input parameters, that input should be validated. As we all know, developers slip once in a while. Legacy applications can also pose a challenge, with code written during a time where security might not have been a priority. Having a "safety net" to help detect and fix such vulnerabilities makes it easier to keep the code base secure.

Redirect validation is slightly opportunistic as of NWebsec 3.0.0, as it's executed in the HttpApplication.EndRequest Event. In most cases, the redirect validation exception will be thrown before the request headers are sent to the client. However, doing e.g. a `Response.Flush()` in a handler will send the headers to the client immediately - before the EndRequest event fires. An exception will be thrown in any case if a non-whitelisted redirect is detected.

## Configuring redirect validation
[[NWebsec]] lets you enable redirect validation in its simplest form with a single line of config:

```xml
<nwebsec>
    <httpHeaderSecurityModule>
        <redirectValidation enabled="true">
    </httpHeaderSecurityModule>
</nwebsec>
```

[[NWebsec.Owin]] lets you do the same with a single line in your OWIN startup class:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseRedirectValidation();
}
```

This configuration will validate all HTTP responses with a status code of 3xx, except 304 (Not Modified). Redirects to relative URIs are allowed, as well as redirects to the same site — meaning the same scheme/host/port. Redirects to other destinations will trigger a _RedirectValidationException_, terminating the response.

Web applications often redirect users from HTTP to HTTPS, this must be explicitly allowed. If the site is running on a non-default HTTPS port, one or more port numbers must be configured. Alslo, if your application needs to redirect to other sites they can be added to a whitelist in config, as such:

```xml
<nwebsec>
    <httpHeaderSecurityModule>
        <redirectValidation enabled="true">
        <allowSameHostRedirectsToHttps enabled="true" />
        <!--<allowSameHostRedirectsToHttps enabled="true" httpsPorts="4567, 7654"/>-->
            <add allowedDestination="http://www.nwebsec.com/"/>
            <add allowedDestination="https://www.google.com/accounts/"/>
        </redirectValidation>
    </httpHeaderSecurityModule>
</nwebsec>
```

For [[NWebsec.Owin]] your startup class would look like:

```c#
using NWebsec.Owin;
...
public void Configuration(IAppBuilder app)
{
    app.UseRedirectValidation(options =>
        options.AllowedDestinations("http://www.nwebsec.com/", "https://www.google.com/accounts/")
               .AllowSameHostRedirectsToHttps());
}
```

In addition to same site redirects, this would allow redirects to anywhere on *http://www.nwebsec.com/* as well as *https://www.google.com/accounts/* and subpaths. Redirects to other destinations will trigger an exception.

As an example based on the above configuration, a redirect to *https://www.google.com/accounts/foo/bar* would be allowed but a redirect to *https://www.google.com/foo/* would raise an exception.
## Final notes
If you're using WIF or depend on identity providers such as Google or Facebook to sign in users, you'll need to add the STS/authentication endpoints to the allowed destinations whitelist.

Make sure to register the redirect validation middleware early in the pipeline. The middleware will not be called if a preceding middleware redirects and terminates the pipeline.
