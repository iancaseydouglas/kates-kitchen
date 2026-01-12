

# K8s Kitchen: Clusters A'la Carte


Other Azure Kubernetes modules are either **too simplistic** (rigid, black-box defaults) or **too complex** (exposing hundreds of variables). This solution covers the entire spectrum: it allows you to deploy enterprise-grade clusters with complex networking, security, and hardware requirements using a radically simple UI.

> ### **Simplify ~~simplify,~~ ~~simplify~~.**

## Features

- Flexible cluster configuration using profiles and feature sets
- Support for the latest Azure provider (version 4.0.1+)
- Granular control over all AKS settings
- Sensible defaults with easy overrides using 'partials'
- Compatibility with Azure CNI networking options

Order up your clusters control plane and nodepools A'la'carte using our **Menu**:

1. **Cluster Profiles (`azure-aks-kontrol`)**: Mix-and-match feature sets for the Control Plane (networking, security, maintenance).
2. **Nodepool Profiles (`azure-aks-knodepool`)**: A vast catalog of worker node configurations (GPU, High-Memory, General Purpose).

---

## 1. Radically Simple Configuration

The key differentiator is that **complex use-cases look just as simple as the basic ones.** You configure your infrastructure by ordering from a menu, not by writing thousands of lines of HCL.

### elegant-cluster.tf

Notice how clean this configuration remains, even when requesting advanced features like overlay networking, specific maintenance windows, and high-performance GPU compute.

```hcl
# 1. Control Plane: Mix-and-match feature sets
module "aks_cluster" {
  source           = "./azure-aks-kontrol"
  aks_config       = var.aks_config
  
  cluster_features = [
    "standard-prod-tier",            # Base production SLA settings
    "azure-cni-overlay",             # Advanced networking profile
    "weekend-maintenance-window",    # Defined maintenance schedule
    "security-hardened-cis"          # CIS Benchmark security settings
  ]
}

# 2. Node Pools: Order hardware from the menu
module "aks_nodepools" {
  source         = "./azure-aks-knodepool"
  cluster_id     = module.aks_cluster.id
  
  # Select exactly the hardware you need by name
  agent_profiles = [
    "general-purpose-xl",           # The workhorse for web apps
    "gpu-tensor-titan",             # For ML model training
    "memory-optimized-mega"         # For Redis/In-memory DBs
  ]
}

```

---

## 2. Cluster Profiles (Control Plane)

The Control Plane module (`azure-aks-kontrol`) allows Platform Engineers to bundle complex configurations into reusable "Cluster Profiles." Instead of tweaking individual flags for API server access, AD integration, or network plugins, you simply select the profiles that match your requirements.

### The Cluster Menu

These profiles are combinable. You can stack a networking profile with a security profile and a maintenance profile.

| Profile Name | Description | Key Features Configured |
| --- | --- | --- |
| `standard-dev` | Development defaults | Free tier, basic networking, no SLA |
| `standard-prod-tier` | Production Baseline | Paid SLA, Availability Zones, Auto-scaling |
| `azure-cni-overlay` | Advanced Networking | Azure CNI Overlay, Pod Subnetting, Cilium (optional) |
| `kubenet-simple` | Basic Networking | Kubenet, simple service CIDR defaults |
| `security-hardened-cis` | Security & Compliance | Private Cluster, Azure Policy, Defender enabled |
| `weekend-maintenance` | Maintenance Window | Auto-upgrade disabled, strict Sunday 2AM patching window |
| `autoscale-conservative` | Scaling Strategy | Slow scale-up/down thresholds to save costs |
| `autoscale-aggressive` | Scaling Strategy | Rapid reaction to spikes for high-traffic APIs |

### Example: High-Security Financial Cluster

```hcl
module "aks_cluster" {
  source           = "./azure-aks-kontrol"
  aks_config       = var.aks_config
  cluster_features = [
    "standard-prod-tier",
    "security-hardened-cis",         # Locks down public access
    "azure-cni-overlay",             # Isolates pod traffic
    "autoscale-aggressive"           # Ensures rapid response to load
  ]
}

```

---

## 3. Node Pool Profiles (The Hardware Menu)

The Nodepool module (`azure-aks-knodepool`) abstracts the complexity of Azure VM SKUs, disk configurations, and sysctls into simple profile names.

### The Nodepool Menu (Excerpt)

*For the full hardware list, including vCPUs, RAM, and specific GPU models, see the **[Full Nodepool Menu](https://www.google.com/search?q=./docs/menu.md)**.*

| Category | Profile Examples | Ideal For |
| --- | --- | --- |
| **General Purpose** | `general-purpose-jr`, `general-purpose-xl` | Web servers, microservices, testing |
| **Compute Optimized** | `compute-optimized-jumbo`, `compute-optimized-mega` | Batch processing, CI/CD runners, gaming servers |
| **Memory Optimized** | `memory-optimized-xl`, `memory-optimized-mega` | Redis, ElasticSearch, Cassandra |
| **GPU (Cosmic)** | `gpu-viz-vega`, `gpu-tensor-titan`, `gpu-quantum-quasar` | AI Training, Video Rendering, LLMs |

---

## 4. Advanced Usage: "Partials" & Overrides

Sometimes the menu isn't enough. You might need a specific taint, a custom label, or a precise disk size. Instead of "ejecting" from the module, you can provide **Partials**.

A "Partial" is a sparse configuration file that only contains the specific values you want to override. The module merges your partial with its internal defaults intelligently.

### How to use Partials

1. Add a custom name to your `agent_profiles` list (e.g., `"my-custom-batch-pool"`).
2. Provide a `.auto.tfvars` file that defines **only the differences**.

**In `main.tf`:**

```hcl
module "aks_nodepools" {
  source         = "./azure-aks-knodepool"
  cluster_id     = module.aks_cluster.id
  agent_profiles = ["general-purpose-xl", "my-custom-batch-pool"]
}

```

**In `my-custom-batch-pool.auto.tfvars`:**

```hcl
# This partial only overrides specific fields. 
# We inherit the OS type, disk config, and networking from defaults.

nodepool_advanced_config = {
  "my-custom-batch-pool" = {
    vm_size             = "Standard_F16s_v2"               # Compute intensive
    node_taints         = ["workload=batch:NoSchedule"]    # Custom Taint
    
    # Deep Linux customization
    linux_os_config = {
       sysctl_config = {
         "vm_max_map_count" = 262144 # Required for ElasticSearch
       }
    }
  }
}

```

---

## 5. Extensibility: Adding to the Menu

The module is designed to be a living catalog. If a "Custom Order" becomes popular, promote it to the Menu.

1. **Update `locals.tf**`: Add the profile to the `nodepool_catalog` or `cluster_features` map.
2. **Update Documentation**: Add the entry to the relevant Menu markdown file.

**Functional Style Guide**:
When extending the code, we strictly prefer a functional style (mappings over loops) to maintain clarity and reducing state-management bugs.

* Use `merge` for combining maps (tags, labels).
* Use `coalesce` to enforce precedence (User Config > Catalog > Default).
* Avoid classes; use static dataclasses or simple maps.

---

## 6. Design Aesthetic

**"A'la Carte-as-Code"**

1. **Simplicity First**: The primary interface is a list of strings.
2. **Separation of Concerns**: All complex logic is hidden in `locals.tf`. The `main.tf` should be readable by a junior developer.
3. **Self-Documenting**: The code *is* the catalog. The variable names match the mental model of the user.
4. **Intelligent Defaults**: We assume the most common "happy path" (e.g., Auto-scaling enabled, Linux OS) so you don't have to type it every time.

**Bon Appétit!**





