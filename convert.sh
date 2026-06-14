#!/usr/bin/env bash
set -euo pipefail

# Converts the legacy Sphinx RST docs to just-the-docs Markdown.
#
# URL layout mirrors the old readthedocs paths so existing links keep working:
#   source/index.rst        -> docs/en/latest/index.md          (/en/latest/)
#   source/nwebsec/<x>.rst  -> docs/en/latest/nwebsec/<x>.md    (/en/latest/nwebsec/<x>.html)

SRC="source/nwebsec"
ROOT="docs/en/latest"          # home (index) lives here
OUT="docs/en/latest/nwebsec"   # everything else lives here
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
convert "source/index.rst" "$ROOT/index.md"
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

convert "$SRC/core-vs-classic.rst" "$OUT/core-vs-classic.md"
emit_fm "$OUT/core-vs-classic.md" "core vs classic" 7
assemble "$OUT/core-vs-classic.md"

# ---- children of "NWebsec libraries" ----
LIBPARENT="NWebsec libraries"
convert "$SRC/NWebsec.AspNetCore.Middleware.rst" "$OUT/NWebsec.AspNetCore.Middleware.md"
emit_fm "$OUT/NWebsec.AspNetCore.Middleware.md" "NWebsec.AspNetCore.Middleware" 1 "$LIBPARENT"
assemble "$OUT/NWebsec.AspNetCore.Middleware.md"

convert "$SRC/NWebsec.AspNetCore.Mvc.rst" "$OUT/NWebsec.AspNetCore.Mvc.md"
emit_fm "$OUT/NWebsec.AspNetCore.Mvc.md" "NWebsec.AspNetCore.Mvc" 2 "$LIBPARENT"
assemble "$OUT/NWebsec.AspNetCore.Mvc.md"

convert "$SRC/NWebsec.AspNetCore.Mvc.TagHelpers.rst" "$OUT/NWebsec.AspNetCore.Mvc.TagHelpers.md"
emit_fm "$OUT/NWebsec.AspNetCore.Mvc.TagHelpers.md" "NWebsec.AspNetCore.Mvc.TagHelpers" 3 "$LIBPARENT"
assemble "$OUT/NWebsec.AspNetCore.Mvc.TagHelpers.md"

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
emit_fm "$OUT/Upgrade-insecure-requests.md" "Upgrade-insecure-requests" 5 "$CFGPARENT"
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

echo "Done."
echo "Home:  $ROOT/index.md"
echo "Pages: $OUT"
ls -1 "$OUT"
