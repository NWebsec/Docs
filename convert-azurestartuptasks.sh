#!/usr/bin/env bash
set -euo pipefail

# Converts the NWebsec.AzureStartupTasks Sphinx RST docs (from the separate
# Docs.AzureStartupTasks repo, copied into source-azurestartuptasks/) to
# just-the-docs Markdown, for the standalone site published at
# /projects/AzureStartupTasks/en/latest/ (see docs-azurestartuptasks/),
# mirroring the old readthedocs "subprojects" URL scheme for this project.
#
#   source-azurestartuptasks/index.rst -> docs-azurestartuptasks/index.md
#   source-azurestartuptasks/<x>.rst   -> docs-azurestartuptasks/nwebsec/<x>.md

SRC="source-azurestartuptasks"
ROOT="docs-azurestartuptasks"        # home (index) lives here
OUT="docs-azurestartuptasks/nwebsec" # everything else lives here
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
convert "$SRC/index.rst" "$ROOT/index.md"
emit_fm "$ROOT/index.md" "Home" 1
assemble "$ROOT/index.md"

# ---- fixup: the :doc: link from the home page resolves relative to $ROOT,
# but its target actually lives under $OUT (nwebsec/) -- add the prefix back.
sed -E -i 's#\]\(TLS-hardening\.html\)#](nwebsec/TLS-hardening.html)#' "$ROOT/index.md"

# ---- top-level pages ----
convert "$SRC/TLS-hardening.rst" "$OUT/TLS-hardening.md"
emit_fm "$OUT/TLS-hardening.md" "TLS hardening" 2
assemble "$OUT/TLS-hardening.md"

# ---- final cleanup pass over every generated page ----
for f in "$ROOT/index.md" "$OUT"/*.md; do
  # strip pandoc's rendered ".. toctree::" blocks (nav comes from front matter instead)
  awk '/<div class="toctree"/{skip=1} skip && /<\/div>/{skip=0; next} !skip' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  # default highlight language is csharp; normalise fence info strings
  sed -E -i -e 's/^``` c#/```csharp/' -e 's/^``` (.*)$/```\1/' "$f"
  # title-reference roles -> emphasis (handles escaped <> inside)
  perl -pi -e 's/<span class="title-ref">(.*?)<\/span>/*$1*/g' "$f"
done

# ---- one-off fixup: the 1.1.0 changelog entry embeds a markdown-style
# link inside the RST source (invalid RST syntax), so pandoc's rst reader
# doesn't recognize it as a link and escapes the brackets literally instead.
sed -E -i 's#\\\[Windows 8\.1 and Windows Server 2012 R2 Update\\\]\(<(http://support\.microsoft\.com/kb/2929781)>\)#[Windows 8.1 and Windows Server 2012 R2 Update](\1)#' "$OUT/TLS-hardening.md"

# ---- one-off fixup: a couple of RST "expanded" literal-block markers
# (text immediately followed by "::" on the same line, collapsing to " :"
# once the second colon is swallowed by the block marker) leave a stray
# " :" behind in the rendered heading text -- strip it.
sed -E -i 's/^(Enabled cipher suites \(highest priority first\)): :$/\1:/' "$OUT/TLS-hardening.md"

# ---- fixup: the :doc:`TLS-hardening` link text used the raw RST filename
# slug since pandoc has no way to know the target's real title -- that only
# lives in this script's emit_fm call. Patch link text to match.
sed -E -i 's#\[TLS-hardening\]#[TLS hardening]#' "$ROOT/index.md"

# ---- one-off addition: reciprocal link back to the main NWebsec docs.
# Plain root-relative path, not a Liquid relative_url filter -- relative_url
# would prepend this site's own baseurl, producing the wrong nested path.
cat >> "$ROOT/index.md" <<'EOF'

## Looking for the other NWebsec docs?

This documentation covers NWebsec.AzureStartupTasks. For the other NWebsec packages, see the [main NWebsec documentation](/en/latest/).
EOF

echo "Done."
echo "Home:  $ROOT/index.md"
echo "Pages: $OUT"
ls -1 "$OUT"
