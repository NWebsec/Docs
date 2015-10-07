It's considered good practice to remove the version number headers commonly emitted by IIS and ASP.NET applications, you've probably seen these before:

>
Server: Microsoft-IIS/8.0  
X-AspNetMvc-Version: 3.0  
X-AspNet-Version: 4.0.30319  
X-Powered-By: ASP.NET

NWebsec helps you suppress almost all of these version headers, i.e. all but the *Server: Microsoft-IIS/8.0* header.

NWebsec.Mvc will disable the MVC version header programatically (through a [PreApplicationStartMethodAttribute](http://haacked.com/archive/2010/05/16/three-hidden-extensibility-gems-in-asp-net-4.aspx)).

The NWebsec package will add the following to your web.config to get rid of the AspNet version header:

```xml
<system.web>
  <httpRuntime enableVersionHeader="false"/>
</system.web>
```

The *X-Powered-By: ASP.NET* header is actually added by the IIS itself. Unfortunately, it doesn't exist in the header collection when any of the ASP.NET events fire in the processing pipeline. To get rid of the *X-Powered-By: ASP.NET* header, NWebsec will add the following to your web.config. This will clear the list of headers added by IIS (except the Server header).

```xml
<configuration>
   <system.webServer>
      <httpProtocol>
         <customHeaders>
            <clear />
         </customHeaders>
      </httpProtocol>
   </system.webServer>
</configuration>
```

Unfortunately, NWebsec no longer removes the "Server" header as of version 3.0. The "Server" header is added by IIS, and can only be removed by an ASP.NET application in the [PreSendRequestHeaders](http://msdn.microsoft.com/en-us/library/system.web.httpapplication.presendrequestheaders.aspx) event. However, in mid 2012 Microsoft published new guidance on [What not to do in ASP.NET, and what to do instead](http://www.asp.net/aspnet/overview/web-development-best-practices/what-not-to-do-in-aspnet,-and-what-to-do-instead), instructing developers to not use the _PreSendRequestHeaders_ event. 

Prior to version 3, NWebsec did its work in the _PreSendRequestHeaders_ event. From version 3, NWebsec uses different events to set headers to avoid issues with async requests. Consequently, the "Server header" can no longer be removed by NWebsec.
 
Note that removing the "Server" header primarily saves you some bandwith, it's not that much of a security improvement. You can use a variety of fingerprinting techniques to detect the IIS version, see e.g. [Fingerprinting IIS](http://blogs.msdn.com/b/vijaysk/archive/2010/09/01/fingerprinting-iis.aspx).

If you're determined to remove the header, there are a few ways you can go about it.
* If you have a load balancer/reverse proxy, it might be able to remove the "Server" header for you.
* You can install UrlScan on each web server to get rid of the "Server" header. For instructions on how to do it by hand, go read [Shhh… don’t let your response headers talk too loudly](http://www.troyhunt.com/2012/02/shhh-dont-let-your-response-headers.html).

Good luck!