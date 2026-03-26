Run the Speckit QA Browser Execution phase.

Tasks:
- verify readiness from existing QA artifacts,
- execute all automatable scenarios,
- capture screenshots and evidence,
- classify failures,
- create or update:
  - `qa/run-log.md`
  - `qa/defects.md`
  - `qa/defect-status.json`
  - `qa/scenario-status.json`
  - `qa/screenshots/`
  - `qa/evidence/`

Retry once only for flaky failures.
Return:
- passed
- failed
- blocked
- major defects
