# Activity 04 — Reject broad ingress with root-only mocks

[Review index](README.md) · [Full setup](00-start-here.md) · [Previous activity](activity-03.md) · [Simulation record](simulation.md)

> Review copy; follow your private copy’s live Exercise issue to do the lab.

<!-- FULL-WS-LESSON:START -->
## Laboratory 03 - Step 4/4

**Goal:** Prove wildcard ingress is rejected by `var.rules`, then pass every learner-root check.

**Work:** your private copy's root, branch `lab/security`.
**File:** edit [tests/security.tftest.hcl](../tests/security.tftest.hcl); read [variables.tf](../variables.tf) and [mock fixtures](../tests/mocks/security.tfmock.hcl).

[Setup](../docs/start-here.md) · [Git help](../docs/git-workflow.md) · [Toolchain](../docs/toolchain.md) · [Recovery](../docs/troubleshooting.md)

### Do 1 — Keep the supplied tests

Preserve all 13 runs, including `valid_two_subnet_associations`, its output/ID assertions, `valid_narrow_inbound` and every rejection. Keep the complete default inputs, synthetic IDs, tags, `mock_provider "azurerm"`, `source = "./tests/mocks"` and `override_during = plan`. Do not redirect tests to another module.

### Do 2 — Append the malicious-ingress rejection

Append this complete run **outside** existing blocks. This is a negative mock fixture, not a deployable recommendation:

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

The **source-address** wildcard violates the ingress guard; the source-port wildcard is allowed. Use `var.rules`, not `var.security_rules`. The same run name in another test file does not satisfy this authored-file gate. Remove `TODO` and save.

### Do 3 — Run focused root checks

In **Terminal → New Terminal** at the clone root, use Node **24.16.0**, Terraform **1.16.1**, AzureRM **5.4.0**. Run separately; stop on unexpected errors:

```powershell
terraform fmt -check -recursive
terraform init -backend=false -lockfile=readonly -input=false
terraform validate
terraform test '-filter=tests\security.tftest.hcl'
```
**Why:** `fmt -check -recursive` checks formatting; `init` downloads locked dependencies with backend disabled, lock read-only and prompts off; `validate` checks configuration; `-filter` selects this file. **Expect:** 14 passes: two positive and 12 intended rejections. Fix formatting/diagnostics; never supply Azure credentials.

On macOS/Linux replace only the last line:

```bash
terraform test '-filter=tests/security.tftest.hcl'
```
**Why:** The selector uses native separators: backslashes on Windows, slashes here. **Expect:** the same 14 executed passes. Quote the whole argument; `Unknown test file`, zero tests or only 13 runs means stop and check the path/saved addition, even with exit 0.

### Do 4 — Run every root test

```powershell
node scripts/check-learner.mjs
```
**Why:** The helper checks the actual learner root without narrowing or redirecting tests. **Expect:** **42** provider-mocked passes: 14 security, 25 rule, two wiring and one separate seeded-regression case; zero failed/errored/skipped. These are expected counts, not an observed result. Any different count or diagnostic needs investigation, not deleted checks.

Keep per-instance wiring overrides: shared mock IDs may intentionally repeat. `Missing expected failure` here means the guard did not reject the input; inspect the input/validation target without weakening it.

> [!WARNING]
> No Azure login, backend/state access or real plan/apply. Mock `command = plan` is not live deployment. RFC1918 containment does not prove least privilege, reachability or an egress policy.

### Do 5 — Save and verify the newest commit

**Save → stage → commit → push → refresh the SAME Exercise.** Review the addition only; use `lab: reject wildcard ingress in the security root` and [Git help](../docs/git-workflow.md).

In **Actions → Lab checks → newest commit → Test learner module**, read the real 42-case summary. AgentAlvine requires the authored rejection and successful current-SHA workflow/job for **4/4**. Old/skipped runs, manual checkboxes and claimed success do not count; no evidence PR or review gate is required.

![GitHub reference showing the Actions tab](../docs/images/github-actions.webp)
*REFERENCE — GitHub, CC BY 4.0; not your run/counts. [Attribution](../docs/images/NOTICE.md).*

Reference-architecture Azure Policy hands-on is a separate planned companion, not implemented or credited by these four checks. GitHub checks never authorize cloud deployment.

**Next:** [Laboratory 04](https://github.com/alvinea28/ws2-terraform-tests-docs-laboratory-04), in its own independent private copy.
<!-- FULL-WS-LESSON:END -->

## Recorded simulation outcome

**2026-09-08 — Cycle A: recorded verified; Cycle B: recorded verified.** Both private simulations recorded the learner-added wildcard-ingress rejection at `var.rules` and the successful learner-root gate, reaching 4/4 offline completion. Each original cycle recorded 42 mocked cases/fixtures; none is live Azure proof.

The 42 cases and the Node suite are whole-lab totals, not additional counts for every activity or repeated run. See the [simulation record and coverage limits](simulation.md).
