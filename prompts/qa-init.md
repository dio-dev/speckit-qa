You are running the QA Initialization phase for a Spec-Driven Development workflow.

Your task:
- inspect the current feature specification, clarifications, implementation plan, and task list,
- identify blockers before execution,
- determine what test data, fixtures, roles, accounts, environments, or workarounds are required,
- produce deterministic QA setup guidance.

You must review:
- user journeys,
- auth or OTP or email or SMS dependencies,
- payment or webhook dependencies,
- feature flags,
- third-party integrations,
- test account needs,
- admin-side setup,
- fixtures or seed needs,
- likely flaky areas.

Output files to create or update:
- `qa/init.md`
- `qa/environment-checklist.md`
- `qa/approved-workarounds.md` if approval-dependent workarounds are proposed.

Do not run browser automation.
Do not generate final bug reports.
Do not say `ready` unless you verified the setup is realistic.

Required readiness status:
- `ready`
- `ready with workarounds`
- `blocked`
