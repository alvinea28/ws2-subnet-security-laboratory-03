# Activity 04 — Reject broad ingress with root-only mocks

[Review index](README.md) · [Full setup](00-start-here.md) · [Previous activity](activity-03.md) · [Simulation record](simulation.md)

> Review copy; follow your private copy’s live Exercise issue to do the lab.

<!-- FULL-WS-LESSON:START -->
## Laboratory 03 - Step 4/4

### Reject wildcard ingress at this root's rules input

| Before you begin | This step |
| --- | --- |
| Goal | Add an intended rejection without removing any supplied mocks or positive/security cases, then pass current-head CI. |
| Time | 15–20 minutes, plus provider download time if needed. |
| Files | Edit only [tests/security.tftest.hcl](../tests/security.tftest.hcl); read [variables.tf](../variables.tf) and [tests/mocks/security.tfmock.hcl](../tests/mocks/security.tfmock.hcl). |
| Starting branch | `lab/security` in the independent private Laboratory 03 copy. |

Beginner guides: [Start here](../docs/start-here.md) · [Git workflow](../docs/git-workflow.md) · [Copilot guide](../docs/copilot-guide.md) · [Toolchain](../docs/toolchain.md) · [Troubleshooting](../docs/troubleshooting.md).

> [!NOTE]
> This standalone root accepts `rules`, **not** `security_rules`. Tests must exercise this root rather than redirect to a reference module.
> A prohibited input should be rejected by its intended validation, not by provider login, malformed IDs, or some unrelated error.

### 1. Preserve the complete supplied test context

1. Confirm this clone and `lab/security`; press **Ctrl+P** → [tests/security.tftest.hcl](../tests/security.tftest.hcl).
2. Keep its existing `mock_provider "azurerm"`, `source = "./tests/mocks"`, and `override_during = plan`.
3. Keep the entire default `variables` block: NSG name, existing group, region, two realistic all-zero-UUID subnet IDs, and required tags.
4. Preserve `valid_two_subnet_associations`: it asserts exactly `web`/`data`, the NSG's mocked ID, and realistic association-ID shapes.
5. Keep `valid_narrow_inbound` and every other supplied rejection. Do not replace this file with only the new run.
6. Press **Ctrl+P** → [variables.tf](../variables.tf) to read the `rules` guard; do not edit it.

### 2. Append this exact rejection run

1. Return with **Ctrl+P** → [tests/security.tftest.hcl](../tests/security.tftest.hcl).
2. At the end, **outside** every existing block, append the following run. It is a mock-only negative test, not a deployable rule recommendation:

```hcl
run "reject_wildcard_ingress" {
  command = plan
  variables {
    rules = {
      public-https = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "10.42.2.0/24"
        description                = "Negative test: reject an unrestricted inbound source."
      }
    }
  }
  expect_failures = [var.rules]
}
```

3. Keep the run name exactly `reject_wildcard_ingress`, retain the supplied runs, remove any `TODO`, and press **Ctrl+S**.
4. The source-port wildcard is a permitted default; the **source-address** wildcard is the deliberate policy violation.
5. A run with this name in another supplied test file does not satisfy the requirement to add it to this learner security test file.

### 3. Run the root checks and the focused file

1. Select **Terminal** → **New Terminal** at the clone root with Node **24.16.0**, Terraform **1.16.1**, and AzureRM **5.4.0**.
2. Run each line separately; backend-disabled initialization can download the locked provider but must not ask for Azure access:

```powershell
terraform fmt -check -recursive
terraform init -backend=false -lockfile=readonly -input=false
terraform validate
terraform test '-filter=tests\security.tftest.hcl'
```

On **macOS/Linux**, replace only the last line with the slash-form selector:

```bash
terraform test '-filter=tests/security.tftest.hcl'
```

3. Windows requires the native backslash selector; quote the **whole argument**, including `-filter=`, rather than only the filename.
4. Expect **14 executed runs** in this file after adding one to the supplied 13, including the new intended rejection.
5. A warning such as `Unknown test file` followed by zero tests is not success even if the process exits without an error.

### 4. Run the full learner checker without narrowing its scope

1. From the same root run:

```powershell
node scripts/check-learner.mjs
```

2. This executes the actual root: 14 security-file cases, 25 rule cases, two wiring cases, and one separate seeded regression after your addition.
3. Expect **42 executed provider-mocked tests**, with none failed, errored, or skipped. This count describes the supplied suite plus your one new run, not an observed result.
4. Read any failed assertion in context. Do not redirect the test to a solution, weaken `var.rules`, delete a case, or remove mock defaults.

The wiring cases use per-instance overrides to verify distinct associations. Some shared mock defaults repeat an ID intentionally.
Keep both the reusable mock fixtures and the more precise wiring checks; do not “repair” a valid fixture by inventing a live resource.

> [!WARNING]
> Do not run Azure login, backend/state commands, or real plan/apply. A mock `command = plan` is not a live deployment instruction.
> RFC1918 containment is a guardrail, not proof of least privilege, zero trust, reachability, or an approved egress policy.

### 5. Review, stage, commit, push, and inspect the newest commit

1. Press **Ctrl+Shift+G** and inspect the security-test diff; verify the addition did not delete any existing case or change the mock provider.
2. Select **+** (**Stage Changes**), inspect **Staged Changes**, enter `lab: reject wildcard ingress in the security root`, and select **Commit**.
3. Select **...** → **Push**; use **Publish Branch** only if this branch was not already published to your copy.
4. Refresh **your own private repository**, select `lab/security` in **Code**, and inspect the newest commit and complete test file.
5. Select **Actions** → **Lab checks** → that newest-commit run → **Test learner module** → the learner-check command log.
6. Find the actual `42 provider-mocked tests passed; no Azure calls.` line, or the first error. Do not use a previous green run as evidence for this commit.
7. Refresh the Exercise **body** after **AgentAlvine** finishes. No manual check command, evidence upload, or review/merge gate is required.

![GitHub reference showing the Actions navigation tab](../docs/images/github-actions.webp)
*REFERENCE — GitHub publisher screenshot, CC BY 4.0. Example repository/counts are not your execution evidence; [attribution](../docs/images/NOTICE.md).*

### Expected result and what AgentAlvine checks

- The specified security test file contains its mock provider, `valid_two_subnet_associations`, `output.association_ids`, the new `reject_wildcard_ingress`, and `expect_failures = [var.rules]`.
- It contains no unfinished text; the learner-check workflow and **Test learner module** job must succeed on the latest observed SHA.
- The issue reaches **4/4** only after those authored-file and CI checks are satisfied, not from a reference-only pass.

### Troubleshooting

| Symptom | Specific recovery |
| --- | --- |
| `Missing expected failure` in your normal root test | The prohibited source was not rejected as expected; inspect the preserved guard and input name, and ask for help rather than suppress the diagnostic. |
| Wrong validation target | Use `var.rules` in this standalone root, not the composed baseline's `var.security_rules`. |
| Only 13 focused runs appear | Reopen the exact learner test with **Ctrl+P**, check where the run was appended, **Ctrl+S**, and rerun the correct native filter. |
| CI is skipped or follows another SHA | Verify the private-copy repository, branch, newest commit, and named job; a template skip never counts. |

**Next action:** start [Laboratory 04](https://github.com/alvinea28/ws2-terraform-tests-docs-laboratory-04) in its own private copy. Its complete baseline and security child are included; do not copy these files across.
<!-- FULL-WS-LESSON:END -->

## Recorded simulation outcome

**2026-09-08 — Cycle A: recorded verified; Cycle B: recorded verified.** Both private simulations recorded the learner-added wildcard-ingress rejection at `var.rules` and the successful learner-root gate, reaching 4/4 offline completion. Each original cycle recorded 42 mocked cases/fixtures; none is live Azure proof.

The 42 cases and the Node suite are whole-lab totals, not additional counts for every activity or repeated run. See the [simulation record and coverage limits](simulation.md).
