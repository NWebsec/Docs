#!/usr/bin/env bash
set -euo pipefail

# Converts the classic ASP.NET 4 Sphinx RST docs to just-the-docs Markdown,
# for the standalone site published at /en/aspnet4/ (see docs-aspnet4/).
#
#   source-aspnet4/index.rst        -> docs-aspnet4/index.md
#   source-aspnet4/nwebsec/<x>.rst  -> docs-aspnet4/nwebsec/<x>.md
#
# Unlike convert.sh, output lives at the docs-aspnet4/ SITE ROOT (not
# nested under an en/aspnet4/ subfolder) -- the /en/aspnet4/ URL prefix
# comes from docs-aspnet4/_config.yml's baseurl plus the CI build's
# placement step, not from source folder nesting.

SRC="source-aspnet4/nwebsec"
ROOT="docs-aspnet4"          # home (index) lives here
OUT="docs-aspnet4/nwebsec"   # everything else lives here
mkdir -p "$ROOT" "$OUT"

# Front matter writer.
# args: outfile, title, nav_order, [parent], [has_children]
emit_fm() {
  local file="$1" title="$2" order="$3" parent="${4:-}" haschildren="${5:-}"
  {
    echo "---"
    echo "title: \"$title\""
    echo "nav_order: $order"
    [ -n "$parent" ] && echo "parent: \"$parent\""
    [ -n "$haschildren" ] && echo "has_children: true"
    echo "---"
    echo ""
  } > "$file.fm"
}

# Convert one rst -> md body (no front matter yet).
convert() {
  local in="$1" out="$2"
  local tmp="/tmp/pp_$(basename "$in")"
  # Rewrite :doc:`Target` -> `Target <Target.html>`_ (RST link form) so pandoc makes a real link.
  sed -E 's/:doc:`([^`<]+)`/`\1 <\1.html>`_/g' "$in" > "$tmp"
  pandoc -f rst -t gfm --wrap=none "$tmp" -o "$out.body"
}

# Combine front matter + body.
assemble() {
  local out="$1"
  cat "$out.fm" "$out.body" > "$out"
  rm -f "$out.fm" "$out.body"
}

# ---- home (index) ----
convert "source-aspnet4/index.rst" "$ROOT/index.md"
emit_fm "$ROOT/index.md" "Home" 1
assemble "$ROOT/index.md"

# ---- top-level pages ----
convert "$SRC/getting-started.rst" "$OUT/getting-started.md"
emit_fm "$OUT/getting-started.md" "Getting started" 2
assemble "$OUT/getting-started.md"

convert "$SRC/libraries.rst" "$OUT/libraries.md"
emit_fm "$OUT/libraries.md" "NWebsec libraries" 3 "" "yes"
assemble "$OUT/libraries.md"

convert "$SRC/Configuration.rst" "$OUT/Configuration.md"
emit_fm "$OUT/Configuration.md" "Configuration" 4 "" "yes"
assemble "$OUT/Configuration.md"

convert "$SRC/Breaking-changes.rst" "$OUT/Breaking-changes.md"
emit_fm "$OUT/Breaking-changes.md" "Breaking changes" 5
assemble "$OUT/Breaking-changes.md"

convert "$SRC/NWebsec-and-the-SDL.rst" "$OUT/NWebsec-and-the-SDL.md"
emit_fm "$OUT/NWebsec-and-the-SDL.md" "NWebsec and the SDL" 6
assemble "$OUT/NWebsec-and-the-SDL.md"

# (no core-vs-classic page here -- that distinction doesn't apply within
# the classic ASP.NET 4 doc set itself)

# ---- children of "NWebsec libraries" ----
LIBPARENT="NWebsec libraries"
convert "$SRC/NWebsec.rst" "$OUT/NWebsec.md"
emit_fm "$OUT/NWebsec.md" "NWebsec" 1 "$LIBPARENT"
assemble "$OUT/NWebsec.md"

convert "$SRC/NWebsec.Owin.rst" "$OUT/NWebsec.Owin.md"
emit_fm "$OUT/NWebsec.Owin.md" "NWebsec.Owin" 2 "$LIBPARENT"
assemble "$OUT/NWebsec.Owin.md"

convert "$SRC/NWebsec.Mvc.rst" "$OUT/NWebsec.Mvc.md"
emit_fm "$OUT/NWebsec.Mvc.md" "NWebsec.Mvc" 3 "$LIBPARENT"
assemble "$OUT/NWebsec.Mvc.md"

# ---- children of "Configuration" ----
CFGPARENT="Configuration"
convert "$SRC/Configuring-cache-headers.rst" "$OUT/Configuring-cache-headers.md"
emit_fm "$OUT/Configuring-cache-headers.md" "Cache headers" 1 "$CFGPARENT"
assemble "$OUT/Configuring-cache-headers.md"

convert "$SRC/Redirect-validation.rst" "$OUT/Redirect-validation.md"
emit_fm "$OUT/Redirect-validation.md" "Redirect validation" 2 "$CFGPARENT"
assemble "$OUT/Redirect-validation.md"

convert "$SRC/Configuring-referrerpolicy.rst" "$OUT/Configuring-referrerpolicy.md"
emit_fm "$OUT/Configuring-referrerpolicy.md" "Referrer-Policy" 3 "$CFGPARENT"
assemble "$OUT/Configuring-referrerpolicy.md"

convert "$SRC/Configuring-csp.rst" "$OUT/Configuring-csp.md"
emit_fm "$OUT/Configuring-csp.md" "Content-Security-Policy" 4 "$CFGPARENT"
assemble "$OUT/Configuring-csp.md"

convert "$SRC/Upgrade-insecure-requests.rst" "$OUT/Upgrade-insecure-requests.md"
emit_fm "$OUT/Upgrade-insecure-requests.md" "Upgrade insecure requests" 5 "$CFGPARENT"
assemble "$OUT/Upgrade-insecure-requests.md"

convert "$SRC/Configuring-hsts.rst" "$OUT/Configuring-hsts.md"
emit_fm "$OUT/Configuring-hsts.md" "Strict-Transport-Security" 6 "$CFGPARENT"
assemble "$OUT/Configuring-hsts.md"

convert "$SRC/Configuring-hpkp.rst" "$OUT/Configuring-hpkp.md"
emit_fm "$OUT/Configuring-hpkp.md" "Public-Key-Pins" 7 "$CFGPARENT"
assemble "$OUT/Configuring-hpkp.md"

convert "$SRC/Configuring-xfo.rst" "$OUT/Configuring-xfo.md"
emit_fm "$OUT/Configuring-xfo.md" "X-Frame-Options" 8 "$CFGPARENT"
assemble "$OUT/Configuring-xfo.md"

convert "$SRC/Configuring-xxss.rst" "$OUT/Configuring-xxss.md"
emit_fm "$OUT/Configuring-xxss.md" "X-Xss-Protection" 9 "$CFGPARENT"
assemble "$OUT/Configuring-xxss.md"

convert "$SRC/Configuring-cto.rst" "$OUT/Configuring-cto.md"
emit_fm "$OUT/Configuring-cto.md" "X-Content-Type-Options" 10 "$CFGPARENT"
assemble "$OUT/Configuring-cto.md"

convert "$SRC/Configuring-xdo.rst" "$OUT/Configuring-xdo.md"
emit_fm "$OUT/Configuring-xdo.md" "X-Download-Options" 11 "$CFGPARENT"
assemble "$OUT/Configuring-xdo.md"

convert "$SRC/Configuring-xrt.rst" "$OUT/Configuring-xrt.md"
emit_fm "$OUT/Configuring-xrt.md" "X-Robots-Tag" 12 "$CFGPARENT"
assemble "$OUT/Configuring-xrt.md"

convert "$SRC/Suppressing-version-headers.rst" "$OUT/Suppressing-version-headers.md"
emit_fm "$OUT/Suppressing-version-headers.md" "Suppressing version headers" 13 "$CFGPARENT"
assemble "$OUT/Suppressing-version-headers.md"

# ---- final cleanup pass over every generated page ----
# Note: perl -0pi (slurp mode) silently no-ops under bash/git-bash here, so the
# multi-line toctree block is stripped with awk instead.
for f in "$ROOT/index.md" "$OUT"/*.md; do
  # strip pandoc's rendered ".. toctree::" blocks (nav comes from front matter instead)
  awk '/<div class="toctree"/{skip=1} skip && /<\/div>/{skip=0; next} !skip' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  # default highlight language is csharp; normalise fence info strings
  sed -E -i -e 's/^``` c#/```csharp/' -e 's/^``` (.*)$/```\1/' "$f"
  # title-reference roles -> emphasis (handles escaped <> inside)
  perl -pi -e 's/<span class="title-ref">(.*?)<\/span>/*$1*/g' "$f"
done

# ---- one-off fixup: Sphinx `:ref:`classic-pipeline`` has no pandoc rst-reader
# support (only `:doc:` is rewritten above) and is the only :ref: usage in
# either RST tree, so it's hand-fixed here rather than built generically.
# Pandoc's rst reader drops the unrecognized :ref: role and renders the
# label as a plain inline code span (`classic-pipeline`), not the raw role
# syntax -- verified by running the conversion and inspecting the output.
# It targets the "IIS 6 or IIS 7 Classic Pipeline Mode" heading further down
# the same page; heading_anchors: true (kramdown/just-the-docs) generates the
# slug #iis-6-or-iis-7-classic-pipeline-mode for that heading.
sed -E -i 's/`classic-pipeline`/[Classic Pipeline Mode](#iis-6-or-iis-7-classic-pipeline-mode)/' "$OUT/Configuration.md"

# ---- fixup: :doc:`Target` link text used the raw RST filename slug (e.g.
# "Configuring-csp") since pandoc has no way to know a target's real title --
# that only lives in this script's emit_fm calls. Patch link text to match.
fix_doc_text() {
  local slug="$1" title="$2"
  SLUG="$slug" TITLE="$title" perl -pi -e '
    my $slug = $ENV{SLUG};
    my $title = $ENV{TITLE};
    s/\[\Q$slug\E\]/[$title]/g;
  ' "$ROOT/index.md" "$OUT"/*.md
}
fix_doc_text "Breaking-changes" "Breaking changes"
fix_doc_text "Redirect-validation" "Redirect validation"
fix_doc_text "Configuring-csp" "Content-Security-Policy"
fix_doc_text "Upgrade-insecure-requests" "Upgrade insecure requests"
fix_doc_text "Configuring-hsts" "Strict-Transport-Security"
fix_doc_text "Configuring-xfo" "X-Frame-Options"
fix_doc_text "Configuring-cto" "X-Content-Type-Options"
fix_doc_text "Configuring-xdo" "X-Download-Options"

# ---- one-off fixup: point the SessionSecurity/AzureStartupTasks "docs here"
# links at their internal standalone sites instead of the old external
# readthedocs URLs baked into source-aspnet4/index.rst.
sed -E -i \
  -e 's#\]\(http://docs\.nwebsec\.com/projects/SessionSecurity/en/latest/\)#](/projects/SessionSecurity/en/latest/)#' \
  -e 's#\]\(http://docs\.nwebsec\.com/projects/AzureStartupTasks/en/latest/\)#](/projects/AzureStartupTasks/en/latest/)#' \
  "$ROOT/index.md"

# ---- one-off addition: reciprocal link back to the ASP.NET Core docs.
# Plain root-relative path, not a Liquid relative_url filter -- relative_url
# would prepend this site's own baseurl (/en/aspnet4), producing the wrong
# /en/aspnet4/en/latest/.
cat >> "$ROOT/index.md" <<'EOF'

## Looking for the ASP.NET Core docs?

This documentation covers the classic ASP.NET 4 packages (`NWebsec`, `NWebsec.Mvc`, `NWebsec.Owin`). For the current ASP.NET Core packages, see the [main NWebsec documentation](/en/latest/).
EOF

echo "Done."
echo "Home:  $ROOT/index.md"
echo "Pages: $OUT"
ls -1 "$OUT"
