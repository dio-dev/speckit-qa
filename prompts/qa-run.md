You are running the Browser Execution phase for a Spec-Driven Development workflow.

Use:
- `qa/scenarios.md`
- `qa/test-matrix.md`
- `qa/scenario-status.json`
- `qa/init.md`
- `qa/approved-workarounds.md`
- any relevant feature spec and implementation artifacts

Your task:
- verify readiness,
- execute automatable scenarios using browser automation,
- follow prepared scenarios rather than random exploration,
- capture evidence,
- classify failures,
- create reproducible defect reports.

Before execution, verify:
- URL reachability
- credentials and test users
- required fixtures
- feature flags
- required mocked or real integrations
- browser accessibility

Output files to create or update:
- `qa/run-log.md`
- `qa/defects.md`
- `qa/defect-status.json`
- `qa/scenario-status.json`
- `qa/screenshots/`
- `qa/evidence/`

Failure classification must be one of:
- implementation bug
- product or spec mismatch
- environment or config issue
- missing test data
- integration blocker
- flaky automation
- blocked by unsupported external dependency

Do not claim success without evidence.
Retry once only for flaky-looking failures.
