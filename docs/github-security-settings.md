# GitHub Security Settings

Repository administrators must enable:

- GitHub CodeQL analysis default setup for Rust;
- private vulnerability reporting;
- Dependabot alerts;
- dependency graph;
- secret scanning and push protection when available;
- branch protection requiring the Rust CI workflow;
- review of workflow changes by `CODEOWNERS`.

CodeQL analysis default setup is active by repository policy. Do not commit an
advanced CodeQL workflow while default setup is enabled.

Development commits are allowed. Finish the implementation and local gates,
commit the completed `AWAITING PENTEST` state, then ask the maintainer to
pentest that exact `HEAD`. After a clean result or completed remediation and
retest, commit the current version with its `PASS` report. Wait for the
maintainer to report GitHub Actions and CodeQL default-setup results. If the
maintainer reports a failure, fix it, update the same report, commit again,
and wait for the next report. Tag only after the maintainer reports that the
latest commit is green and explicitly asks.
