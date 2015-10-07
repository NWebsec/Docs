NWebsec currently consists of a [[HttpHeaderModule]] that lets you manage HTTP headers. It can remove version headers, as well as output various security HTTP headers.

* See [[Getting started]] if you're the impatient type.
* See [[Configuration]] to study NWebsec's configuration section.
* See [[Configuring cache headers]] to set secure cache headers.
* See [[Suppressing version headers]] to figure out how you can get rid of version headers.
* See [[Redirect validation]] to avoid unvalidated redirect vulnerabilities.
* See [[Configuring X-Robots-Tag]] to learn how to use the Robots Exclusion Protocol (REP) through HTTP headers.
* See [[Configuring security headers]] for a detailed explanation on how to configure each security header.
* See [[Configuring Content Security Policy]] to learn more about the Content Security Policy header.
* See [[NWebsec.Mvc]] to discover how you can configure security headers for your MVC application through the NWebsec MVC attributes.

# Security headers
Supported security headers are:

* X-Frame-Options
* Strict-Transport-Security
* X-Content-Type-Options
* X-Download-Options
* X-XSS-Protection
* Content-Security-Policy / Content-Security-Policy-Report-Only
* Public-Key-Pins / Public-Key-Pins-Report-Only