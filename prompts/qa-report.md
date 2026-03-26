You are running the QA Reporting phase for a Spec-Driven Development workflow.

Use:
- `qa/run-log.md`
- `qa/defects.md`
- `qa/defect-status.json`
- `qa/scenario-status.json`
- `qa/scenarios.md`
- `qa/init.md`

Your task:
- summarize actual QA execution,
- report coverage,
- report failures and blockers,
- provide a release or merge recommendation.

Output files to create or update:
- `qa/report.md`
- `qa/summary.json`

Overall status must be one of:
- `pass`
- `pass with issues`
- `fail`
- `blocked`

Release recommendation must be one of:
- `safe to merge`
- `safe to merge with known minor issues`
- `do not merge until blockers are fixed`
- `retest required after fixes`

Do not soften severe issues.
Do not hide blockers.
Do not overstate coverage.
