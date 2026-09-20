#!/usr/bin/env bash
set -euo pipefail

# Converts the NWebsec.SessionSecurity Sphinx RST docs (from the separate
# Docs.SessionSecurity repo, copied into source-sessionsecurity/) to
# just-the-docs Markdown, for the standalone site published at
# /projects/SessionSecurity/en/latest/ (see docs-sessionsecurity/), mirroring
# the old readthedocs "subprojects" URL scheme for this project.
#
#   source-sessionsecurity/index.rst  -> docs-sessionsecurity/index.md
#   source-sessionsecurity/<x>.rst    -> docs-sessionsecurity/nwebsec/<x>.md

SRC="source-sessionsecurity"
ROOT="docs-sessionsecurity"        # home (index) lives here
OUT="docs-sessionsecurity/nwebsec" # everything else lives here
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

# ---- fixup: :doc: links from the home page resolve relative to $ROOT, but
# their targets actually live under $OUT (nwebsec/) -- unlike sibling pages
# linking to each other (already correctly relative), the home page needs
# the nwebsec/ prefix added back in.
sed -E -i \
  -e 's#\]\(Authenticated-session-identifiers\.html\)#](nwebsec/Authenticated-session-identifiers.html)#' \
  -e 's#\]\(Configuring-session-security\.html\)#](nwebsec/Configuring-session-security.html)#' \
  "$ROOT/index.md"

# ---- top-level pages ----
convert "$SRC/Configuring-session-security.rst" "$OUT/Configuring-session-security.md"
emit_fm "$OUT/Configuring-session-security.md" "Configuring session security" 2
assemble "$OUT/Configuring-session-security.md"

convert "$SRC/Authenticated-session-identifiers.rst" "$OUT/Authenticated-session-identifiers.md"
emit_fm "$OUT/Authenticated-session-identifiers.md" "Authenticated session identifiers" 3 "" "yes"
assemble "$OUT/Authenticated-session-identifiers.md"

# ---- children of "Authenticated session identifiers" ----
convert "$SRC/AuthenticatedSessionIDManager.rst" "$OUT/AuthenticatedSessionIDManager.md"
emit_fm "$OUT/AuthenticatedSessionIDManager.md" "AuthenticatedSessionIDManager" 1 "Authenticated session identifiers"
assemble "$OUT/AuthenticatedSessionIDManager.md"

# ---- final cleanup pass over every generated page ----
for f in "$ROOT/index.md" "$OUT"/*.md; do
  # strip pandoc's rendered ".. toctree::" blocks (nav comes from front matter instead)
  awk '/<div class="toctree"/{skip=1} skip && /<\/div>/{skip=0; next} !skip' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  # default highlight language is csharp; normalise fence info strings
  sed -E -i -e 's/^``` c#/```csharp/' -e 's/^``` (.*)$/```\1/' "$f"
  # title-reference roles -> emphasis (handles escaped <> inside)
  perl -pi -e 's/<span class="title-ref">(.*?)<\/span>/*$1*/g' "$f"
done

# ---- one-off fixup: the home page's Sphinx `:doc:`` `` role has an empty
# target (source-sessionsecurity/index.rst originally pointed cross-project
# at the main NWebsec docs' "NWebsec and the SDL" page, which readthedocs
# subprojects can't easily cross-link -- the source itself ships it broken).
# Point it at that page's real URL in the main site instead. Plain
# root-relative path, not a Liquid relative_url filter -- relative_url would
# prepend this site's own baseurl, producing the wrong nested path.
sed -E -i 's#No\? See :doc:\\`\\` to learn more\.#No? See [NWebsec and the SDL](/en/latest/nwebsec/NWebsec-and-the-SDL.html) to learn more.#' "$ROOT/index.md"

# ---- fixup: :doc:`Target` link text used the raw RST filename slug (e.g.
# "Configuring-session-security") since pandoc has no way to know a target's
# real title -- that only lives in this script's emit_fm calls. Patch link
# text to match.
fix_doc_text() {
  local slug="$1" title="$2"
  SLUG="$slug" TITLE="$title" perl -pi -e '
    my $slug = $ENV{SLUG};
    my $title = $ENV{TITLE};
    s/\[\Q$slug\E\]/[$title]/g;
  ' "$ROOT/index.md" "$OUT"/*.md
}
fix_doc_text "Authenticated-session-identifiers" "Authenticated session identifiers"
fix_doc_text "Configuring-session-security" "Configuring session security"

# ---- one-off addition: reciprocal link back to the main NWebsec docs.
# Plain root-relative path, not a Liquid relative_url filter -- relative_url
# would prepend this site's own baseurl, producing the wrong nested path.
cat >> "$ROOT/index.md" <<'EOF'

## Looking for the other NWebsec docs?

This documentation covers NWebsec.SessionSecurity. For the other NWebsec packages, see the [main NWebsec documentation](/en/latest/).
EOF

echo "Done."
echo "Home:  $ROOT/index.md"
echo "Pages: $OUT"
ls -1 "$OUT"
