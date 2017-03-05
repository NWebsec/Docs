ASP.NET Core vs ASP.NET 4
=========================

NWebsec saw the light of day back in 2012 and initially included an `HttpModule` that set security headers for ASP.NET applications. NWebsec (still) targets both .NET 3.5 and .NET 4. NWebsec.Mvc later introduced MVC filter attributes. NWebsec.Owin was created after Microsoft released their Katana project, bringing the OWIN ideas to ASP.NET 4.

ASP.NET Core, a major redesign and rewrite of ASP.NET, emerged as the "new" ASP.NET during 2016. Consequently, the NWebsec.AspNetCore packages were released in early versions. These packages target up-to-date versions of the .NET framework, the new abstractions in ASP.NET Core, and has no ties to the "old" ASP.NET.

Efforts will be focused on the NWebsec.AspNetCore libraries in the future. The number of downloads for these packages are quickly rising and is expected to outgrow the "old" packages in the near future. With Visual Studio 2017, ASP.NET Core projects will be a natural selection for new web applications since the changes to the project files are over. With stability in the project system, stability will come to the (3'rd party) tooling as well.

This does not mean that the "old" version of NWebsec is dead in any way. The library will be maintained, so if there should surface any bugs those would be considered seriously. But new features will be included in the ASP.NET Core libraries, and will not on a regular basis be backported to the old libraries.