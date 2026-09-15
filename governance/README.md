# Governance companion: observe before enforcing

**Goal:** manage one disposable Azure Policy assignment through Terraform/Git,
then observe, fix and clean up with the [hands-on guide](../docs/policy-hands-on.md).
Terraform AVM supplies the separately owned workload; Policy uses **native
AzureRM**, not an invented AVM module. No Bicep or Sentinel.

## Files and boundary

- [main.tf](main.tf): Terraform **1.16.1**, AzureRM **4.81.0**, built-in lookup
  `azurerm_policy_definition.require_tag` (**Require a tag on resources**) and
  `azurerm_resource_group_policy_assignment.lesson`. The fixed tag is
  `ws2-policy-demo`; `enforce = false` means **DoNotEnforce**, not an Audit effect.
- [variables.tf](variables.tf): scope, assignment name and acknowledgement inputs.
- [tests/scope.tftest.hcl](tests/scope.tftest.hcl): two provider-mocked plan contracts,
  including rejection when dedicated-scope acknowledgement is false.

This root owns **only the assignment**, not the existing RG, built-in definition
or workload. Keep its dependencies/state separate from baseline AzureRM **5.4.0**.
No live backend is configured here; it is **not connected to the baseline Lab 07
workflow**. Do not substitute this folder into that workflow.

## Entry checks and your own inputs

Complete [first-time setup](../docs/start-here.md). Before any future live work,
complete [Azure setup](../docs/azure-setup.md) and have the instructor confirm actual
scope permissions, dedicated-RG inventory, costs, cleanup ownership and protected
delivery. Contributor/read access alone is insufficient for assignments.

Supply live inputs privately through the approved writer; the Azure guide's
environment variables do **not** automatically populate Terraform inputs.

| Input | Your value |
| --- | --- |
| `tenant_id` | Your `AZURE_TENANT_ID` |
| `subscription_id` | Your `AZURE_SUBSCRIPTION_ID` |
| `resource_group_name` | Your `WORKLOAD_RG`, confirmed existing and dedicated |
| `name` | Unique `ws2-policy-` prefix plus 2–26 lowercase alphanumeric/hyphen characters, first alphanumeric |
| `dedicated_scope_confirmed` | Defaults **false**; acknowledge **true** only after approval; never bypass the precondition |
| `enforce` | Start **false**; **true** needs a separate approved denial experiment |

Never commit actual IDs, credentials, private inputs, plans or state.

## Non-Azure validation only

```powershell
# From the repository root: credential-free fmt -check, backend-disabled read-only init, schema validate and exactly 2 mocked contract cases (zero failures/errors/skips); not live delivery, original Exercise completion proof or AgentAlvine progress.
node scripts/check-companion.mjs
```

Use a clean, credential-free authoring checkout, without CLI login/cache, Azure/OIDC
credentials or live backend initialization. A reviewed profile-specific provider
lockfile is supplied with Windows/Linux provider hashes. Do not drop readonly
locking or copy the incompatible baseline lock.

From the **Lab 03 clone root**, run each command separately, stopping on any error:

```powershell
terraform -chdir=governance init -backend=false -lockfile=readonly -input=false
terraform -chdir=governance validate
terraform -chdir=governance test
```

**Why:** `-chdir=governance` selects this companion. `init` installs providers;
`-backend=false` skips backend initialization, `-lockfile=readonly` forbids lock
changes and `-input=false` prevents prompts. Downloads need registry access, not
Azure access. `validate` checks configuration/provider schemas; `test` uses mocked
providers and synthetic inputs. Backend disabling alone does not make live plans safe.

**Authoring result:** configuration validation and **2 contract cases passed**.
Require both cases to execute with no failures/skips; a tested rejection counts
as success. These are not workshop completion or live compliance/denial proof.

## Separately approved LIVE lifecycle

Only after instructor designation of the **approved Terraform root/state**, encrypted
locked backend and protected writer: initialize using that approved backend procedure,
not the offline initialization above. The writer uses `plan` with `-out` to save
the proposal, independent human review of the encrypted plan, then `apply` of that
**exact plan**. Creation and enforcement changes stay in Git/Terraform; Portal is
read-only for settings/compliance.

Cleanup requires a fresh full `plan -destroy` (`-destroy` proposes all owned
resources), saved with `-out`, independently reviewed and applied through the same
writer/state. Remove only the assignment, then clean the workload through its
**separate original root/state**. No Portal deletion, targets, RG/backend/shared
resource deletion or state removal. Verify absence privately; uncertainty stays open.

### Full cleanup commands — approved writer only

**Future live use, not authoring or PR CI.** From the clone root, the designated
writer must already have this original backend/workspace and private inputs
initialized. Its plan/apply identities, concurrency, encrypted plan handling and
independent approval must remain enforced; these snippets do not configure them.

1. Protected **plan stage**:

  ```powershell
  terraform -chdir=governance plan -destroy -input=false '-out=cleanup.tfplan'
  if ($LASTEXITCODE -ne 0) { throw 'Destroy plan failed; stop.' }
  ```

  **Meaning:** `-chdir` selects this root, `-destroy` proposes every owned
  resource's removal, `-input=false` rejects missing-input prompts and `-out`
  saves the exact plan here. Expect **only this assignment** to be deleted.
2. **Stop for independent review** of the encrypted, bound saved plan through the
  approved procedure. Do not share/commit the plan or replan after approval.
  Only the protected apply stage may decrypt those same reviewed bytes here:

  ```powershell
  terraform -chdir=governance apply -input=false cleanup.tfplan
  if ($LASTEXITCODE -ne 0) { throw 'Cleanup incomplete; keep the exercise open.' }
  ```

  **Meaning:** applies the exact saved plan, **without a second approval prompt**;
  the external protected approval is mandatory.
3. Authorized state verification:

  ```powershell
  terraform -chdir=governance state list
  if ($LASTEXITCODE -ne 0) { throw 'State verification failed; stop.' }
  ```

  **Expected:** no managed assignment entry, with its absence separately verified
  in Azure. Keep the built-in definition and existing RG; the workload belongs
  to its separate writer. Empty state alone does not prove Azure cleanup.
