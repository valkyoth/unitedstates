#!/usr/bin/env sh
set -eu

test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

printf '%s\n' \
    '#!/usr/bin/env sh' \
    'value="portable"' \
    'test -n "$value"' \
    >"$test_root/portable.sh"
printf '%s\n' \
    '#!/usr/bin/env bash' \
    'value=<(printf "%s\n" "bash")' \
    'test -e "$value"' \
    >"$test_root/bash.sh"

SHELL_SCRIPT_ROOT="$test_root" scripts/check_shell_syntax.sh

printf '%s\n' \
    '#!/usr/bin/env sh' \
    'value="unterminated' \
    >"$test_root/invalid.sh"
if SHELL_SCRIPT_ROOT="$test_root" scripts/check_shell_syntax.sh \
    >/dev/null 2>&1; then
    echo "invalid POSIX shell syntax was accepted" >&2
    exit 1
fi
rm "$test_root/invalid.sh"

printf '%s\n' \
    '#!/usr/bin/python3' \
    'print("not a shell script")' \
    >"$test_root/unsupported.sh"
if SHELL_SCRIPT_ROOT="$test_root" scripts/check_shell_syntax.sh \
    >/dev/null 2>&1; then
    echo "unsupported shell shebang was accepted" >&2
    exit 1
fi

echo "shell syntax regression tests passed"
