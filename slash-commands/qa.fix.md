Run the Speckit QA defect remediation phase.

Tasks:
- inspect `qa/defects.md` and `qa/defect-status.json`,
- select the relevant existing defect,
- implement the fix,
- run the narrowest credible retest,
- update:
  - `qa/fix-log.md`
  - `qa/defects.md`
  - `qa/defect-status.json`
  - `qa/run-log.md`
  - `qa/scenario-status.json`

Return:
- defect ids addressed
- retest result
- remaining risk
