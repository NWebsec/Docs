The NWebsec HttpHeaderModule controls which headers are sent in the response from and ASP.NET application. Since it's an HttpModule it works for both Web Forms application and MVC applications as it hooks into the [ASP.NET/IIS pipeline](http://msdn.microsoft.com/en-us/library/bb470252.aspx). There, it makes changes to the HTTP header collection according to the NWebsec configuration.

The HttpHeaderModule supports the following security headers (See [[Configuration]] for the actual web.config):

* X-Frame-Options
* Strict-Transport-Security
* X-Content-Type-Options
* X-Download-Options
* X-XSS-Protection
* Content-Security-Policy
* Experimental Content Security Policy headers
  * X-Content-Security-Policy/X-Content-Security-Policy-Report-Only
  * X-WebKit-CSP/X-WebKit-CSP-Report-Only

In addition to adding these headers, the HttpHeaderModule can suppress the common ASP.NET version headers:

* X-AspNet-Version
* X-AspNetMvc-Version

Note that as of NWebsec 3.0 you can no longer override the "Server" header value, due to deprecation of the PreSendRequestHeaders event in the ASP.NET pipeline. 

# Benefits
The HttpHeaderModule lets you set common security headers without any code changes, it is loaded and configured strictly through web.config.  This is a quick win for the security of ASP.NET applications. Security of legacy applications can be improved quite easily as well. The flexibility of the configuration means that various parts of an application can run with different configurations.