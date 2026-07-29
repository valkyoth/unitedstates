#!/usr/bin/env sh
set -eu

old_identity='swe''den|swed''ish|trafik''verket|SWE''-[0-9]'
identity_root="${IDENTITY_ROOT:-.}"

if rg -n -i "$old_identity" "$identity_root" \
    --hidden \
    --glob '!.git/**' \
    --glob '!.agents/**' \
    --glob '!.codex/**' \
    --glob '!target/**'; then
    echo "copied source-project identity remains in the repository" >&2
    exit 1
fi
