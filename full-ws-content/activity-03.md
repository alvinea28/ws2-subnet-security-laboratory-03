# Activity 03 — Compose the child with synthetic inputs

[Review index](README.md) · [Full setup](00-start-here.md) · [Previous activity](activity-02.md) · [Next activity](activity-04.md) · [Simulation record](simulation.md)

> Review copy; follow your private copy’s live Exercise issue to do the lab.

<!-- FULL-WS-LESSON:START -->
## Laboratory 03 - Step 3/4

### Demonstrate composition without discovering infrastructure

| Before you begin | This step |
| --- | --- |
| Goal | Point the included example at this security root and inject complete synthetic subnet IDs. |
| Time | 10–15 minutes. |
| Files | Edit only [examples/basic/main.tf](../examples/basic/main.tf); keep reusable-root inputs and resources unchanged. |
| Starting branch | `lab/security` in your private Laboratory 03 copy. |

Beginner guides: [Start here](../docs/start-here.md) · [Git workflow](../docs/git-workflow.md) · [Copilot guide](../docs/copilot-guide.md) · [Toolchain](../docs/toolchain.md) · [Troubleshooting](../docs/troubleshooting.md).

> [!NOTE]
> A caller passes dependencies through inputs. This example requires no earlier network-module copy or deployed subnet.
> Full Azure-shaped IDs demonstrate the input format; the all-zero UUID is intentionally synthetic and is not a login credential.

### 1. Open the example, not the reusable implementation

1. Confirm this clone and `lab/security` in VS Code.
2. Press **Ctrl+P**, enter [examples/basic/main.tf](../examples/basic/main.tf), and press **Enter**.
3. Read the supplied `module "security"` caller, its two subnet IDs, its required tags, and the configured provider at the bottom.
4. Replace the unfinished module `source` with `"../.."` and remove the unfinished top comment.
5. Keep all complete caller fields and the supplied **example-only** provider configuration. Use the full result below to check your edit.

### 2. Keep this complete synthetic caller

```hcl
# Mock-only composition example; never plan or apply this caller against Azure.
module "security" {
  source = "../.."

  name                = "ws2-security"
  resource_group_name = "rg-ws2-existing"
  location            = "southeastasia"
  subnet_ids = {
    web  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ws2-existing/providers/Microsoft.Network/virtualNetworks/ws2-network/subnets/web"
    data = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ws2-existing/providers/Microsoft.Network/virtualNetworks/ws2-network/subnets/data"
  }
  tags = {
    owner       = "team"
    environment = "dev"
    cost_center = "training"
    workshop    = "ws2"
  }
  rules = {}
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
```

1. Press **Ctrl+S** after the edit. Do not replace the all-zero UUID with a real subscription value.
2. Confirm the distinct `/subnets/web` and `/subnets/data` endings; a VNet ID alone is not a subnet ID.
3. Do not add data sources, resource-group creation, subnets, VMs, credentials, or a backend to make these IDs “real.”
4. Keep the configured provider in this example caller only; do not copy it into the reusable root.

### 3. Explain the input boundary

| Example feature | What a new consumer should understand |
| --- | --- |
| `source = "../.."` | From the basic example's directory, two parent levels reach this repository's standalone security module. |
| `subnet_ids` | The caller supplies a stable-key map of subnet IDs; the child has no need to create or discover them. |
| UUID and resource path | IDs must have a realistic full shape even in mocks so provider/schema parsing is meaningful. |
| Four tags | Nonblank `owner`, `environment`, `cost_center`, and `workshop` are part of the input contract. |
| `rules = {}` | No custom rules are requested; built-in NSG defaults are not removed or transformed into zero trust. |
| Provider outside the module | A consumer configures providers; a reusable child declares requirements and inherits configuration. |

The provider block in the example is not a mock by itself. **Do not initialize or execute this example as a live root.**
Provider-mocked tests run from the authored repository root; they are separate from this illustrative caller.
No repository from another laboratory is referenced by this local source path.

An optional read-only Copilot prompt after attaching this example and the root inputs with `#`:

```text
Explain why injecting subnet_ids makes this child independently reusable.
Check the two synthetic ID shapes and required tags against the supplied inputs.
Distinguish the example's configured provider from the root test mock.
Do not add lookups, edit files, run commands, or contact Azure.
```

### 4. Check formatting, then commit the one-file change

1. Select **Terminal** → **New Terminal** and verify you are still at the repository root.
2. With Node **24.16.0**, Terraform **1.16.1**, and the supplied AzureRM **5.4.0** lock, check formatting only:

```powershell
terraform fmt -check 'examples/basic/main.tf'
```

3. For a formatting error, reopen the same path with **Ctrl+P**, fix two-space indentation/alignment, and press **Ctrl+S**.
4. Press **Ctrl+Shift+G**, select the example diff under **Changes**, and verify the source points locally to this module.
5. Select **+** (**Stage Changes**), inspect **Staged Changes**, enter `lab: demonstrate injected subnet IDs`, and select **Commit**.
6. Select **...** → **Push**; use **Publish Branch** only if this branch has not previously been published.

> [!WARNING]
> No Azure login, state access, backend initialization, or real plan/apply belongs here. Synthetic identifiers do not make live commands safe.
> Preserve the supplied validation and version pins; do not weaken UUID validation to accept invented short IDs.

### 5. Find the exact branch and workflow result

1. Refresh **your own private copy's Code** page, select `lab/security`, and open its newest commit and the example file.
2. Select **Actions** → **Lab checks** → the run for that newest commit → **Test learner module**.
3. Expand the learner-check command and read the actual first error line or provider-mocked summary.
4. Do not interpret a green job as proof that the illustrative example was deployed, or that the next authored-test gate is complete.
5. Refresh the existing Exercise **body** when **AgentAlvine** finishes; it should present the wildcard rejection task.

![Microsoft reference showing Source Control Push](../docs/images/vscode-push.png)
*REFERENCE — Microsoft publisher screenshot, CC BY 3.0 US. Example branch/repository labels are not your private copy; [attribution](../docs/images/NOTICE.md).*

### Expected result and what AgentAlvine checks

- The pushed example contains `module "security"`, local source `"../.."`, a `subnet_ids` map, the all-zero UUID, both subnet paths, `cost_center`, and `rules`.
- It has no `TODO`, `REPLACE_ME`, resource-group resource, or subnet data lookup.
- These are composition-content checks. The final step separately proves the learner root's mocked behavior.

### Troubleshooting

| Symptom | Specific recovery |
| --- | --- |
| Source points to a missing child | Set it to exactly `"../.."` from this example directory, not a sibling repository or a solution folder. |
| ID rejected by validation | Keep the complete subscription UUID and resource path ending in a named subnet; do not shorten it to a VNet ID. |
| A live provider asks for credentials | Stop: you ran the example instead of the approved root mock route; do not supply credentials. |
| GitHub still shows unfinished source | Check save, staged diff, commit, push, and selected own-copy branch before changing anything else. |

**Next action:** continue to [Step 4: add the wildcard rejection to the learner test file](activity-04.md).
<!-- FULL-WS-LESSON:END -->

## Recorded simulation outcome

**2026-09-08 — Cycle A: recorded verified; Cycle B: recorded verified.** Both private simulations recorded the example caller pointing at the local security root with complete synthetic web/data subnet IDs, tags, and rules input. The example was not provisioned against Azure.

Whole-lab Node and mocked-case totals are not per-activity test counts. See the [simulation record and coverage limits](simulation.md).
