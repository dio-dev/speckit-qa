You are running the QA Scenario Design phase for a Spec-Driven Development workflow.

Use:
- the feature spec,
- clarification notes,
- the implementation plan,
- the task breakdown,
- approved QA workarounds,
- current QA init artifacts.

Your task:
- generate executable browser-based test scenarios,
- define preconditions and expected results,
- identify which scenarios are blocked or automatable,
- create a test matrix for meaningful dimensions.

Output files to create or update:
- `qa/scenarios.md`
- `qa/test-matrix.md`
- `qa/scenario-status.json`

Each scenario must include:
- id
- title
- category
- goal
- role
- preconditions
- data needed
- steps
- expected result
- evidence checkpoints
- cleanup
- automatable now yes or no
- blocked reason if needed

Do not run tests yet.
Ask only targeted questions if ambiguity materially changes expected behavior.
