#!/usr/bin/env sh
set -eu

mode="${1:-check}"
if [ "$mode" != "check" ]; then
    echo "usage: scripts/validate-modularity-policy.sh check" >&2
    exit 2
fi

violations="$(
    find . \
        \( -path './.git' -o -path './target' -o -path './.agents' -o \
        -path './.codex' -o -path './rfc' \) -prune -o \
        -type f \
        \( -name '*.rs' -o -name '*.py' -o -name '*.sh' -o \
        -name '*.yml' -o -name '*.yaml' -o -name '*.toml' \) \
        -exec wc -l {} \; |
        awk '$1 > 500 { print }'
)"
if [ -n "$violations" ]; then
    echo "first-party code or configuration files exceed 500 lines:" >&2
    echo "$violations" >&2
    exit 1
fi

for crate in \
    unitedstates \
    unitedstates-core; do
    test -f "crates/${crate}/Cargo.toml"
    test -f "crates/${crate}/README.md"
    test -f "crates/${crate}/src/lib.rs"
done
