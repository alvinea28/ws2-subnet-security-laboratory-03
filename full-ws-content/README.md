# Laboratory 03 — Full workshop review

> Review copy; follow your private copy’s live Exercise issue to do the lab.

[Full first-time setup](00-start-here.md) · [Enter your Azure values and sign in](azure-setup.md) · [Original simulation summary and verification limits](simulation.md) · [Repository landing page](../README.md)

All four lessons mirror the Exercise text; only relative Markdown links **outside code fences** are rebased. Use Node **24.16.0**, Terraform **1.16.1**, AzureRM **5.4.0**. No earlier lab is required.

| Activity | Full lesson | Cycle A | Cycle B |
| --- | --- | --- | --- |
| 01 | [Create the NSG from caller inputs](activity-01.md) | Recorded verified | Recorded verified |
| 02 | [Map rules and associate supplied subnets](activity-02.md) | Recorded verified | Recorded verified |
| 03 | [Compose the child with synthetic inputs](activity-03.md) | Recorded verified | Recorded verified |
| 04 | [Reject broad ingress with root-only mocks](activity-04.md) | Recorded verified | Recorded verified |

These **2026-09-08 private simulations** each recorded **4/4 offline completion**, not a reader's progress. Whole-lab counts are not per-activity tests or live security-policy proof.

## Use your own Exercise

1. Copy once from the [landing page](../README.md), clone/open it and use **your copy's Exercise link**, not the source Preview.
2. On `lab/security`, **Save → stage → commit → push → refresh the SAME Exercise**. [Git help](../docs/git-workflow.md) explains each action.
3. Inspect **Actions → Lab checks → newest commit → Test learner module**. AgentAlvine uses real GitHub events to update the same issue body; no manual checkboxes, evidence PR or review gate.

Checks exercise the learner root with mocks and synthetic IDs, without Azure credentials/OIDC/state. They never authorize cloud deployment. The additional [Azure Policy hands-on guide](policy-hands-on.md) is copied in full with rebased links: observation-first assignment, Terraform AVM tag repair and scoped cleanup. It is outside these four gates and the original 33-step grader; no new integration evidence or screenshot-based credit is claimed.

## Public source preview — read only, not your learner issue

[Source Exercise #1](https://github.com/alvinea28/ws2-subnet-security-laboratory-03/issues/1) was observed on **2026-09-14** as a read-only instructor Preview, step 0 (**0/4**). It is neither private Cycle A/B nor your learner issue.

![Actual public Exercise preview for Laboratory 03 — new 2026-09-14 capture, not a completed simulation](images/exercise-preview.png)

*Actual 2026-09-14 source Preview capture, not a September 8 participant screenshot. [Provenance](images/provenance.json) records its timestamp and SHA-256; no new capture is claimed.*

[2026-09-14 local verification](simulation.md#fresh-2026-09-14-verified-results) is separate from participant progress. If the Exercise is missing, refresh README/Issues, inspect **Actions → AgentAlvine** and follow [recovery](../docs/troubleshooting.md#agentalvine-or-the-exercise-is-missing). Never choose Preview in a learner copy or bypass repository policy.
