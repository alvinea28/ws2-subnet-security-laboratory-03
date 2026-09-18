# Laboratory 03 · Independent subnet security

**Public source template (not the clone URL after copying):** [alvinea28/ws2-subnet-security-laboratory-03](https://github.com/alvinea28/ws2-subnet-security-laboratory-03) · **Recommended order:** 03 of 08 · **Time:** 60–90 minutes

**Goal:** Build an NSG, map custom rules and subnet associations, then reject unsafe ingress with root-only mocks. **This lab is independent:** supplied synthetic IDs replace earlier-lab dependencies; no Azure resources are needed.

**Tools:** Git, desktop VS Code, Node **24.16.0**, Terraform **1.16.1**; AzureRM **5.4.0** stays pinned.

## Start here

**Windows x64:** [prepare all tools and VS Code extensions in one go](https://github.com/alvinea28/ws2-workshop-catalogue/blob/dev/docs/windows-setup.md#2-paste-this-one-command)
before cloning. Run once for all eight labs; after READY/restart, skip manual installs below.

1. **Install/sign in:** [install the tools](docs/toolchain.md); restart VS Code. GitHub **Sign up** → verify email, or sign in to your personal account. Accept any assigned organization invitation.
2. **Copy once:** **COPY EXERCISE** below or **Use this template → Create a new repository**. Keep **Private** and the `-laboratory-03` suffix. Already copied? Reuse it.
3. **Clone/open:** copy **your copy's Code → HTTPS URL**. VS Code **Ctrl+Shift+P** (macOS **Cmd+Shift+P**) → **Git: Clone**, paste, choose destination, **Open**. Trust only the clone; Explorer must show it, not its parent.
4. **Accounts/tools:** complete [account, authorship and readiness checks](docs/start-here.md). Verify VS Code's GitHub/Copilot sign-in and seat separately; commit name/email is not authentication.
5. **Exercise:** refresh your copy's README/Issues; open its **Exercise**, branch `lab/security`. **Save → stage → commit → push → refresh the SAME Exercise**; [Git help](docs/git-workflow.md).

![Microsoft reference: cloning in VS Code](docs/images/vscode-clone-github.png)
*REFERENCE — Microsoft, CC BY 3.0 US; not your account/repository. [Attribution](docs/images/NOTICE.md).*

<!-- AGENTALVINE:START -->
## Copy this exercise once

[![Copy exercise](.github/images/copy-exercise.svg)](https://github.com/new?template_owner=alvinea28&template_name=ws2-subnet-security-laboratory-03&owner=%40me&name=my-ws2-subnet-security-laboratory-03&visibility=private)

Select the intended Owner, keep **Private**, leave **Include all branches** off, and create the copy. Its own AgentAlvine issue will appear automatically.
<!-- AGENTALVINE:END -->

## Review and boundaries

Read [all four lessons, setup and historical simulation proof](full-ws-content/README.md). The [public source Exercise #1](https://github.com/alvinea28/ws2-subnet-security-laboratory-03/issues/1) is a **read-only instructor Preview, 0/4**, not your learner issue.

[Azure values/sign-in](docs/azure-setup.md) is separate setup, not required by these credential-free mocks. Issue progress permits no deployment/state access. The additional [Azure Policy hands-on guide](docs/policy-hands-on.md) covers observation-first assignment, Terraform AVM tag repair and scoped cleanup; it is outside the four checks and original 33-step grader. Live prerequisites/approvals and actual evidence remain separate; no integration run is claimed.

AgentAlvine updates the same issue from real work, never manual checkboxes/evidence commands. Missing Exercise or failed checks? [Recovery](docs/troubleshooting.md).

[All eight numbered laboratories](https://github.com/alvinea28/ws2-workshop-catalogue) · [MIT code license](LICENSE) · [Screenshot licenses](docs/images/NOTICE.md)
