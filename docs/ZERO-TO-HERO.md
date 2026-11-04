# Zero-to-Hero Project Guide — Azure Production Landing Zone

## 1. Business scenario
An enterprise has multiple teams and subscriptions. Each team provisions Azure differently: inconsistent identity permissions, public endpoints, missing tags, weak logging and no common network model. The platform team needs a repeatable landing-zone baseline before workloads are onboarded.

## 2. Problem statement and target outcome
Build a governed Azure foundation that standardizes subscription hierarchy, identity, network connectivity, policy guardrails, private service access, monitoring and Terraform delivery. The goal is controlled autonomy: teams can deploy workloads without bypassing enterprise controls.

## 3. Architecture walkthrough
1. Entra ID authenticates human and workload identities.
2. Management groups and subscriptions create governance and isolation boundaries.
3. Azure Policy audits or denies non-compliant configurations.
4. Hub/spoke networking centralizes shared connectivity while isolating workloads.
5. Private endpoints plus private DNS provide private PaaS access.
6. Log Analytics/Azure Monitor collect platform diagnostics.
7. Terraform CI validates and plans changes before approved deployment.

## 4. Tool-by-tool: what it does and why
| Tool/service | Purpose | Why selected / interview point |
|---|---|---|
| Terraform | Declarative infrastructure and repeatability | Reviewable plans, reusable modules, drift visibility |
| AzureRM provider | Terraform-to-Azure API integration | Provider versions must be constrained and locked |
| Azure CLI | Authentication and resource verification | Use explicit subscription context |
| Microsoft Entra ID / Azure RBAC | Identity and authorization | Least privilege; separate control-plane and data-plane roles |
| Azure Policy | Governance guardrails | Audit first, then deny; exemptions need owner and expiry |
| VNet, peering, UDR, NSG | Network segmentation and routing | Explain hub-spoke trade-offs and effective routes |
| Private Endpoint / Private DNS | Private PaaS access | DNS and routing are equally important |
| Azure Monitor / Log Analytics | Diagnostics and operational visibility | Configure diagnostic settings and retention deliberately |
| GitHub Actions | CI validation and plan workflow | OIDC, protected environments, approval and audit trail |
| Checkov / TFLint (where configured) | IaC security and lint checks | Static scans complement, not replace, deployment tests |

## 5. End-to-end delivery flow
Discover requirements → define management/subscription boundaries → design address spaces and DNS → implement modules → fmt/init/validate → lint/security scan → plan → peer review → protected apply → verify Azure resources, policy compliance, DNS, routing and diagnostics.

## 6. Commands to know
```bash
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan
az account show
az account set --subscription "<subscription-id>"
az network vnet list -o table
az policy assignment list --scope "<scope>" -o table
```
Never paste credentials or state contents into logs.

## 7. Scenario-based interview questions and answers
**Q1. A team creates a Storage Account with public access. How do you prevent recurrence?**  
A: Apply a policy initiative at the correct management-group/subscription scope, initially audit existing impact, remediate exceptions, then deny public access. Add IaC scanning in PRs, and verify effective policy compliance after deployment.

**Q2. A private endpoint exists but the workload cannot reach the service. How do you troubleshoot?**  
A: Check endpoint approval/state, private DNS zone and VNet link, A record, DNS resolver path, effective routes, NSGs/firewall and service firewall settings. Test name resolution and TCP connectivity from the workload subnet.

**Q3. Why not put every resource in one Terraform state?**  
A: A single state increases blast radius, contention and permission coupling. Split state by lifecycle/ownership (network, identity, shared services, workloads), secure backend access and define dependencies explicitly.

**Q4. Azure Policy denies a legitimate deployment. What next?**  
A: Identify the policy definition/assignment and evaluated alias, determine whether the design is non-compliant or policy is too broad, propose a narrow exemption with owner/expiry and compensating control, then update policy or workload code through review.

**Q5. What proves this is production-ready?**  
A: Deployed resource IDs, role-assignment review, policy compliance results, connectivity/DNS tests, diagnostic ingestion, backup/recovery evidence and operational ownership. Terraform validate is not deployment evidence.

## 8. Troubleshooting playbook
- Terraform auth failure: verify tenant, subscription, identity federation and role scope.
- Wrong subscription: run az account show before any destructive command.
- Peering works but traffic fails: inspect UDR, NSG, firewall and overlapping CIDRs.
- Private endpoint resolves publicly: inspect private DNS zone links and resolver forwarding.
- Policy blocks deployment: capture assignment ID, definition, scope and evaluated field.

## 9. Security, reliability and cost considerations
Separate platform and workload identities; use PIM/JIT for privileged actions; protect remote state; restrict public ingress; centralize audit logs; plan IP capacity; monitor firewall/log ingestion costs; avoid unnecessary cross-region traffic.

## 10. Zero-to-Hero learning sequence
Learn Azure hierarchy and Entra/RBAC → VNet/subnets/NSG/UDR → private endpoints and DNS → Azure Policy → Terraform modules/state → GitHub Actions OIDC → diagnostics → deploy a sandbox and collect real evidence.

## 11. Scope honesty
This guide describes the architecture and practices. Claim only resources and controls actually present in the repository and deployed to a subscription. Label each item implemented, CI-validated, deployed or planned.
