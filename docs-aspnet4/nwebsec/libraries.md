---
title: "NWebsec libraries"
nav_order: 3
has_children: true
---

# NWebsec libraries (ASP.NET 4)


NWebsec is made up of several libraries, each offering different approaches to improve the security of your web applications.

## NWebsec

[NWebsec](NWebsec.html) lets you add security headers and other features to your applications through an HTTP module that is loaded and configured through web.config. This makes it fairly easy to improve the security of legacy apps, as it requires no changes to code.

## NWebsec.Owin

[NWebsec.Owin](NWebsec.Owin.html) offers OWIN middleware for many of NWebsec's features.

## NWebsec.Mvc

[NWebsec.Mvc](NWebsec.Mvc.html) configures NWebsec through MVC attributes. This is useful when you need to do adjustments to the application wide config from NWebsec/NWebsec.Owin, for particular controllers or actions. Some developers prefer to minimize their web.config, and configure most things through code. They can use the NWebsec.Mvc attributes as an alternative to web.config for most features.
