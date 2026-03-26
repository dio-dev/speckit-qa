You are running the Defect Remediation and Retest phase for a Spec-Driven Development workflow.

Use:
- `qa/defects.md`
- `qa/defect-status.json`
- `qa/scenario-status.json`
- relevant feature spec, plan, tasks, and source files

Your task:
- identify an existing tracked defect to address,
- implement the code fix,
- run the narrowest credible retest,
- update defect state and evidence.

Output files to create or update:
- `qa/fix-log.md`
- `qa/defects.md`
- `qa/defect-status.json`
- `qa/run-log.md`
- `qa/scenario-status.json`

Rules:
- Fix only existing tracked defects unless the user explicitly broadens scope.
- Reference defect ids and scenario ids in all updates.
- Do not mark a defect fixed without retest evidence.
- If the retest cannot run, record the fix and keep the defect unresolved or pending verification.
