# United States Release Runbook

1. Finish exactly one version's bounded deliverables.
2. Update tests, documentation, changelog, and version release notes.
3. Run `scripts/checks.sh`, `cargo deny check`, `cargo audit`, and the matching
   version gate.
4. Development commits are allowed throughout. Commit the completed
   `AWAITING PENTEST` state and ask the maintainer to pentest that exact
   `HEAD`.
5. Update `security/pentest/vX.Y.Z.md` with the maintainer's result.
6. If there are findings, fix them, update the same report, and rerun the gates.
   Repeat until the report says `Status: PASS`.
7. If there are no findings, record that clearly and set `Status: PASS`.
8. Commit the complete implementation, pentest outcome, remediation when
   needed, release metadata, and report together.
9. Wait for the maintainer to report the GitHub Actions and CodeQL result.
10. If the maintainer reports a GitHub failure, fix it, update the same report,
    commit again, and wait for the maintainer's next GitHub result.
11. When the maintainer reports that GitHub is green, wait for the maintainer
    to explicitly request tagging.
12. Only then create the requested `vX.Y.Z` tag at the approved commit.
13. Run `scripts/release_crates.py --version X.Y.Z --require-tag`; it publishes
    only crates marked for that release, in dependency order.

Development and remediation commits are unrestricted, but every pentest target
and outcome commit keeps the same version report current. There is no
automatic tag or automatic assumption that GitHub is green.

The `unitedstates` facade always equals and publishes with the tag. Unchanged
subcrates retain their existing versions and are skipped. At `v1.0.0`, all
workspace crates converge to `1.0.0` and publish.
