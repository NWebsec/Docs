###################
NWebsec Tag Helpers
###################

NWebsec includes tag helpers to help generate CSP nonces. Import the tag helpers in the `_ViewImports.cshtml`, alongside those from Microsoft:

..  code-block:: c#

    @addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers
    @addTagHelper *, NWebsec.AspNetCore.Mvc.TagHelpers

Then you can easily include a CSP nonce on script or style tags in your views:

..  code-block:: html

    <script nws-csp-add-nonce="true">
        alert('Nonce added');
    </script>

    <style nws-csp-add-nonce="true"></style>

NWebsec will generate nonces, add them to the CSP header, and include them in the markup:

..  code-block:: html

    <script nonce="buoc1h8zWh0qITh/RHq1">
        alert('Nonce added');
    </script>
    <style nonce="Gn&#x2B;BKIciW17bcffZtx5o"></style>

The nonce values will of course change between requests.