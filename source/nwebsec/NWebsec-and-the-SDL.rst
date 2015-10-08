###################
NWebsec and the SDL
###################

You might be familiar with Microsoft's `Security Development Lifecycle <http://microsoft.com/sdl>`_ (SDL)  — a software security assurance process. The SDL is how Microsoft ensures that security is taken care of throughout their development processes. It's broken down in sections for different development phases and each section contains requirements and recommendations to ensure both security and privacy in their software. They've published the process guidance to aid others in introducing security activities in their own development processes. 

Many of the requirements and recommendations are concrete and actionable — this page lists the SDL requirements that NWebsec will help you fulfill (the others you'll have to take care of yourself #kthxbai :).

These requirements are from the *SDL Process Guidance Version 5.2 released May 23, 2012*.

****************
Session fixation
****************

From *Phase Two Design, Security Recommendations:*

	Strong log-out and session management. Proper session handling is one of the most important parts of web application security. At the most fundamental level, sessions must be initiated, managed, and terminated in a secure manner. If a product employs an authenticated session, it must begin as an encrypted authentication event to avoid session fixation.

You need to take care of the encryption by running your web application over TLS, but session fixation is taken care of when you combine that recommendation with:

	Authentication events must invalidate unauthenticated sessions and create a new session identifier.

[[NWebsec.SessionSecurity]] ensures that unauthenticated sessions IDs aren't reused for authenticated sessions and prevents session fixation attacks through the means of [[Authenticated session identifiers]].

*****************************
The X-Download-Options header
*****************************

From *Phase Two Design, Security Recommendations:*

	Apply no-open header to user-supplied downloadable files. Use the HTTP Header X-Download-Options: noopen for each HTTP file download response that may contain user-controllable content. Recommended tool: Casaba Passive Security Auditor.

See :doc:`Configuring-xdo` to let NWebsec add this header for you.

*********************************
The X-Content-Type-Options header
*********************************

From *Phase Three Implementation. Security Requirements:*

	Internet Explorer 8 MIME handling: Sniffing OPT-OUT. This recommendation addresses functionality new in Internet Explorer 8 that may have security implications in some cases. It is recommended that for each HTTP response that could contain user controllable content, you utilize the HTTP Header X-Content-Type-Options:nosniff. The `Watcher tool <http://websecuritytool.codeplex.com/>`_ may be of use in meeting this requirement.

See :doc:`Configuring-cto` to let NWebsec add this header for you.

************************************
The Content-Security-Policy header
************************************

From *Phase Three Implementation. Security Recommendations:*

	Do not use the JavaScript eval() function (or equivalents). The JavaScript eval() function is used to interpret a string as executable code. While eval() enables a web application to dynamically generate and execute JavaScript (including JSON), it also opens up potential security holes, such as injection attacks, where an attacker-fed string may also get executed. For this reason, the eval() function or functional equivalents, such as setTimeout() and setInterval(), should not be used.

See :doc:`Configuring-csp` to let NWebsec add this header for you — CSP will disable all these JavaScript functions (see the *script-src* directive in section 4.2 of the `CSP specification <http://www.w3.org/TR/CSP/#script-src>`_).

**************************
The X-Frame-Options header
**************************

From *Phase Three Implementation. Security Recommendations:*

	ClickJacking defense. For each page that could contain user controllable content, you should use a "frame-breaker" script and include the HTTP response header named X-FRAME-OPTIONS in each authenticated page. The Watcher tool may be of use in meeting this recommendation. The exit criteria for this recommendation is as follows:

	1. A "frame-breaker" script is included in each authenticated page to prevent unintentionally framing.
	2. The X-FRAME-OPTIONS header has been added to all authenticated page HTTP responses that should not be framed (for example, DENY) or is utilized to only allow trusted sites to frame site content (for example, the current site with the use of SAMEORIGIN).

See :doc:`Configuring-xfo` to let NWebsec add this header for you. Also remember that you need to take care of the "frame-breaker" script to fully meet this requirement.

*******************
Redirect validation
*******************

From *Phase Three Implementation. Security Requirements:*

	Safe redirect, online only. Automatically redirecting the user (through Response.Redirect, for example) to any arbitrary location specified in the request (such as a query string parameter) could open the user to phishing attacks. Therefore, it is recommended that you not allow HTTP redirects to arbitrary user-defined domains.

See :doc:`Redirect-validation` to add enable the NWebsec safety net for unvalidated redirect vulnerabilities.