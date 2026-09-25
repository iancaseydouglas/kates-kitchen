# AKS Kontrol: Control Planes a'la Carte

Order an AKS control plane off the menu. A throwaway sandbox and a locked-down production cluster are ordered the same way: pick a profile, add some features.

> ***Be complex, but not complicated. Be simple, but not simplistic.***

## Order Up

```hcl
module "aks" {
  source           = "./azure-aks-kontrol"
  aks_config       = var.aks_config
  cluster_profile  = "standard"
  cluster_features = ["azure_cni_overlay_net", "weekend_maintenance", "autoscale_conservative"]
}
```

```hcl
# cluster.auto.tfvars
aks_config = {
  name                = "my-cluster"
  location            = "westus"
  resource_group_name = "platform-sbx-rg"
  default_node_pool   = {}
}
```

That's the whole interface. Nodepools come from the sibling [`azure-aks-knodepool`](../azure-aks-knodepool/) module.

## The Menu

### Profiles (pick one)

`cluster_profile` sets the base: the system node pool, SKU tier, and support plan.

| Profile | System pool | Notes |
| --- | --- | --- |
| `basic` | 2–5 × `Standard_D2ads_v5` | Sandbox |
| `standard` | 2–5 × `Standard_D4ads_v5` | Free tier. **Default** |
| `premium` | 2–5 × `Standard_D4ads_v5`, 3 nodes | |
| `advanced` | 3–5 × `Standard_D8ads_v5`, zones 1/2/3 | Standard tier, Azure network policy |

### Features (pick any)

`cluster_features` stacks on top of the profile. Order matters: later features win.

| Feature | What you get |
| --- | --- |
| **Networking** | |
| `azure_cni_standard_net` | Azure CNI with Azure network policy |
| `azure_cni_overlay_net` | Azure CNI Overlay, pod CIDR `172.16.0.0/16` |
| `azure_cni_dynamic_net` | Azure CNI, transparent mode |
| `azure_cni_static_cidr_net` | Azure CNI, pod CIDR `10.244.0.0/16` |
| **Security & Identity** | |
| `private_cluster` | Private API server, system-managed private DNS, no public FQDN |
| `enhanced_security` | Azure Policy + Microsoft Defender |
| `azure_rbac` | Entra ID–managed Azure RBAC |
| `oidc_workload_id` | OIDC issuer + Workload Identity |
| `key_vault_secrets` | Key Vault CSI driver, 2-minute secret rotation |
| **Scaling** | |
| `autoscale_conservative` | Slow to scale down; scale-down threshold 0.3 |
| `autoscale_moderate` | Balanced; threshold 0.5 |
| `autoscale_aggressive` | Fast in both directions; threshold 0.7 |
| **Maintenance** | |
| `weekend_maintenance` | Sat 22:00 – Sun 06:00 |
| `weeknight_maintenance` | Tue–Thu 01:00 – 05:00. **Default** |
| **Observability & Cost** | |
| `analytic_monitoring` | OMS agent + managed Prometheus metrics |
| `agentless_monitoring` | Managed Prometheus metrics, all labels and annotations |
| `cost_analysis` | AKS cost analysis |

The menu *is* the code: profiles live in [`cluster_profiles.tf`](./cluster_profiles.tf), features in [`cluster_features.tf`](./cluster_features.tf).

## Off the Menu: Partials

Need something the menu doesn't have? Don't eject. Put only the values you care about in `aks_config`; leave everything else to the kitchen.

```hcl
aks_config = {
  name                = "payments"
  location            = "eastus2"
  resource_group_name = "payments-prd-rg"
  default_node_pool   = { vm_size = "Standard_D8ads_v5" }

  api_server_access_profile = {
    authorized_ip_ranges = ["203.0.113.0/24"]
  }
}
```

The full schema is [`aks_config` in `variables.tf`](./variables.tf). Every field except `name`, `location`, `resource_group_name` and `default_node_pool` is optional.

## How It Stacks

Each layer is deep-merged over the one before it:

```
defaults  →  cluster_profile  →  cluster_features[0..n]  →  aks_config
```

A partial is a layer like any other, so a complex cluster is just a longer list.

## Adding to the Menu

When a custom order gets popular, promote it:

1. Add a key to `feature_sets` in `cluster_features.tf` (or `cluster_profiles` in `cluster_profiles.tf`), shaped like `aks_config`.
2. Add a row to the menu above.

Keep the rules:

- The interface stays a list of strings.
- Complexity goes in `locals`, never in the caller's config.
- Maps and merges over loops and conditionals.

## Requirements

| Name | Version |
| --- | --- |
| terraform | >= 1.8.0 |
| hashicorp/azurerm | >= 4.0.1 |
| isometry/deepmerge | >= 1.0.0 |
| hashicorp/random | >= 3.0.0 |

## Outputs

| Name | Description |
| --- | --- |
| `cluster_id` | AKS cluster ID |
| `cluster_name` | AKS cluster name |
| `cluster_fqdn` | Cluster FQDN |
| `node_resource_group` | Auto-generated node resource group |
| `kube_config` | Kubeconfig (sensitive) |
| `kube_admin_config` | Admin kubeconfig (sensitive) |
| `client_certificate` | Client certificate (sensitive) |
| `rendered_template` | Generated name from the naming schema |

**Bon Appétit!**
