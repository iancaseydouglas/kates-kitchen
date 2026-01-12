# AKS Cluster a'la carte

These Terraform modules build an Azure Kubernetes Service (AKS) cluster master [control plane](https://github.com/iancaseydouglas/modulosos/tree/bcb9a1ecd6156300f971396a656a9256906d3ee9/azure-aks-kontrol) and minion [node pools](https://github.com/iancaseydouglas/modulosos/tree/bcb9a1ecd6156300f971396a656a9256906d3ee9/azure-aks-knodepool).

#### [control plane](https://github.com/iancaseydouglas/modulosos/tree/bcb9a1ecd6156300f971396a656a9256906d3ee9/azure-aks-kontrol)

#### [node pool](https://github.com/iancaseydouglas/modulosos/tree/bcb9a1ecd6156300f971396a656a9256906d3ee9/azure-aks-knodepool)

## See our Menu

Order a cluster a'la carte, by choosing from a menu of options. Clusters simple or complex are deployed with the same simple UI.

Prefer to control every last detail of your cluster configuration? Skip the menu and drop an external file with whatever details you need. 

The module supports configuration using "partials", so you only ever need to provide those values you want to specify. The rest you can leave to us. Just provide your partials according the data input schema defined in the `aks_config` .

## Features

- Flexible cluster configuration using profiles and feature sets
- Support for the latest Azure provider (version 4.0.1+)
- Granular control over all AKS settings
- Sensible defaults with easy overrides using 'partials'
- Compatibility with Azure CNI networking options

## Usage

```hcl
module "aks" {
  source = "path/to/module"  
  aks_config = var.aks_config
  cluster_profile = "standard"
  cluster_features = ["weekend_maintenance", "azure_cni_overlay_net", "autoscale_conservative"]
  cluster_profile  = "standard"
}
```

The above configuration used a tfvars file `*.auto.tfvars` as follows:

```hcl
aks_config = {
  name                = "abhinavagupta"
  location            = "westus"
  resource_group_name = "plaform-sbx-rg"
}
```


