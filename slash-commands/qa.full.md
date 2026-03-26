Run the full Speckit QA workflow.

Execution order:
1. qa.init
2. qa.scenarios
3. qa.run
4. qa.report

Rules:
- stop before execution if readiness is blocked,
- ask only targeted questions when absolutely necessary,
- persist artifacts after each phase,
- reuse existing QA artifacts when possible

Return:
- readiness status
- scenario counts
- key blockers
- key defects
- final recommendation
