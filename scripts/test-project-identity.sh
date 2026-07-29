#!/usr/bin/env sh
set -eu

test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

mkdir -p "$test_root/.github/workflows"
printf '%s\n' '# United States' >"$test_root/README.md"

IDENTITY_ROOT="$test_root" scripts/check_project_identity.sh

old_package='swe''den-core'
printf 'run: cargo check -p %s\n' "$old_package" \
    >"$test_root/.github/workflows/ci.yml"

if IDENTITY_ROOT="$test_root" scripts/check_project_identity.sh \
    >/dev/null 2>&1; then
    echo "copied source-project package name was accepted" >&2
    exit 1
fi

printf '%s\n' 'run: cargo check -p unitedstates-core' \
    >"$test_root/.github/workflows/ci.yml"
IDENTITY_ROOT="$test_root" scripts/check_project_identity.sh

mkdir -p "$test_root/.github"
old_timezone='Europe/Stock''holm'
printf 'timezone: %s\n' "$old_timezone" \
    >"$test_root/.github/dependabot.yml"

if IDENTITY_ROOT="$test_root" scripts/check_project_identity.sh \
    >/dev/null 2>&1; then
    echo "copied source-project timezone was accepted" >&2
    exit 1
fi

printf '%s\n' 'timezone: Etc/UTC' \
    >"$test_root/.github/dependabot.yml"
IDENTITY_ROOT="$test_root" scripts/check_project_identity.sh

echo "project identity regression tests passed"
