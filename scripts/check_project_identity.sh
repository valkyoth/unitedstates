#!/usr/bin/env sh
set -eu

old_identity='swe''den|swed''ish|trafik''verket|SWE''-[0-9]|Europe/Stock''holm'
identity_root="${IDENTITY_ROOT:-.}"

matches="$(
    find "$identity_root" \
        -type d \
        \( -name .git -o -name .agents -o -name .codex -o -name target -o \
        -name .cargo-deny-advisory-dbs \) \
        -prune -o \
        -type f -exec grep -n -i -E "$old_identity" {} + 2>/dev/null ||
        true
)"

if [ -n "$matches" ]; then
    printf '%s\n' "$matches"
    echo "copied source-project identity remains in the repository" >&2
    exit 1
fi
