###########################
Configuring Referrer Policy
###########################

The referer (sic) request header sent by the browsers whenever you follow a link or load resources on the web has privacy implications. Referrer Policy gives website owners more control over the information shared via the referer header.

The Referrer Policy specification is under development at the time of writing, you can track the progress here: `Referrer policy spec <http://www.w3.org/TR/referrer-policy/>`_.

.. note::
	
	Initial browser support for referrer policy is through a meta tag. There have been changes to the policy keywords in the spec, which means that some browsers need to "catch up" with the spec.
	Chrome and Firefox are up to date per October 2015. Edge supports the old keywords in the spec and needs to catch up.

NWebsec provides an HtmlHelper that lets you generate a meta tag with the referrer policy.

**************************
Choosing a Referrer policy
**************************

There are five alternatives when setting a referrer policy.

None
====

*none* is the most restrictive setting, instructing the browser to not send the referer header for requests triggered from the page.

..	code-block:: c#

	@Html.ReferrerPolicyMetaTag(policy => policy.None)

The resulting meta tag is:

..	code-block:: xml
	
	<meta name="referrer" content="none" />

None when downgrade
===================
*none-when-downgrade* instructs the browser to not include the referer header for requests to http resources when triggered from a page loaded over https.

..	code-block:: c#

	@Html.ReferrerPolicyMetaTag(policy => policy.NoneWhenDowngrade)

The resulting meta tag is:

..	code-block:: xml
	
	<meta name="referrer" content="none-when-downgrade" />


Origin
======
*origin* instructs the browser to only include the page's origin in the referrer header. E.g. for https://www.nwebsec.com/somepage the browser will include https://www.nwebsec.com/ in the referer header.

..	code-block:: c#

	@Html.ReferrerPolicyMetaTag(policy => policy.Origin)

The resulting meta tag is:

..	code-block:: xml
	
	<meta name="referrer" content="origin" />
	
Origin when cross origin
========================
*origin-when-crossorigin* intructs the browser to include the full referer header to same origin navigations/resource loads, but include the page's origin for navigations/resources loaded from a different origin.

..	code-block:: c#

	@Html.ReferrerPolicyMetaTag(policy => policy.OriginWhenCrossOrigin)

The resulting meta tag is:

..	code-block:: xml
	
	<meta name="referrer" content="origin-when-crossorigin" />

Unsafe URL
========================
*unsafe-url* intructs the browser to include the full referer header all navigations/resource loads.

.. warning::
	
	This setting will make the browser share referrer information in more situations than with the default browser behaviour. Use this setting only after careful consideration of the privacy implications for your users.

..	code-block:: c#

	@Html.ReferrerPolicyMetaTag(policy => policy.OriginWhenCrossOrigin)

The resulting meta tag is:

..	code-block:: xml
	
	<meta name="referrer" content="origin-when-crossorigin" />
