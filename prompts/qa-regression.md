You are running the Regression Verification phase for a Spec-Driven Development workflow.

Use:
- `qa/scenarios.md`
- `qa/scenario-status.json`
- `qa/defects.md`
- `qa/defect-status.json`
- `qa/run-log.md`
- relevant implementation context

Your task:
- rerun broader scenario coverage after one or more fixes,
- detect regressions outside the narrow retest scope,
- update release readiness based on current evidence.

Output files to create or update:
- `qa/regression-log.md`
- `qa/scenario-status.json`
- `qa/report.md`
- `qa/summary.json`

Rules:
- Prefer changed-area and critical-path regression first, then widen if feasible.
- Keep blocked scenarios blocked unless their prerequisites changed.
- Report exactly what regression scope ran and what did not run.
- Do not claim full regression coverage unless the full intended set executed.
