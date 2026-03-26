Run a targeted QA retest.

Tasks:
- read `qa/scenario-status.json`, `qa/defects.md`, and `qa/defect-status.json`,
- identify previously failed or blocked scenarios that are now likely testable,
- rerun only relevant scenarios,
- update:
  - `qa/run-log.md`
  - `qa/defects.md`
  - `qa/defect-status.json`
  - `qa/scenario-status.json`
  - `qa/report.md`
  - `qa/summary.json`

Do not rerun already passed scenarios unless explicitly necessary.
Return a delta summary versus the previous run.
