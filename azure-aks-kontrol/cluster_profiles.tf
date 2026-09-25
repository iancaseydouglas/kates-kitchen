locals {
  vms = {
    small  = "Standard_D2ads_v5"
    medium = "Standard_D4ads_v5"
    large  = "Standard_D8ads_v5"
  }

  cluster_profiles = {
    basic = {
      default_node_pool = {
        node_count           = 2
        vm_size              = local.vms.small
        os_sku               = "AzureLinux"
        auto_scaling_enabled = true
        min_count            = 2
        max_count            = 5
      }
      # disabled due to plan error 
      ## │ Error: Inconsistent conditional result types
      ## │
      ## │   on ../azure-aks-kontrol/locals.tf line 62, in locals:
      ## │   62:   profile_config = var.cluster_profile != null ? provider::deepmerge::mergo(local.base_config, local.cluster_profiles[var.cluster_profile]) : local.base_config
      ## │     ├────────────────
      ## │     │ local.base_config is object with 12 attributes
      ## │     │ local.cluster_profiles is object with 6 attributes
      ## │     │ var.cluster_profile is "basic"
      ## │
      ## │ The true and false result expressions must have consistent types. Type mismatch for object attribute "default_node_pool": The 'true' value includes object attribute "auto_scaling_enabled", which is absent in the 'false' value.
      ## ╵
      # network_profile = {
      #   network_plugin = "azure"
      #   network_policy = "azure"
      # }
      # sku_tier     = "Free"
      # support_plan = "KubernetesOfficial"
    }
    standard = {
      default_node_pool = {
        name                 = "system"
        node_count           = 2
        vm_size              = local.vms.medium
        os_sku               = "AzureLinux"
        auto_scaling_enabled = true
        min_count            = 2
        max_count            = 5
      }
      # network_profile = {
      #   network_plugin      = "azure"
      #   network_plugin_mode = "overlay"
      #   pod_cidr            = "172.16.30.0/10"
      #   service_cidr        = "10.244.64/16"
      #   network_policy      = "azure"
      #   load_balancer_sku   = "standard"
      # }
      sku_tier     = "Free"
      support_plan = "KubernetesOfficial"
    }
    premium = {
      default_node_pool = {
        name                 = "system"
        vm_size              = local.vms.medium
        os_sku               = "AzureLinux"
        auto_scaling_enabled = true
        min_count            = 2
        max_count            = 5
        node_count           = 3
      }
      sku_tier     = "Standard"
      support_plan = "KubernetesOfficial"
    }
    advanced = {
      default_node_pool = {
        name                 = "system"
        node_count           = 3
        vm_size              = local.vms.large
        auto_scaling_enabled = true
        min_count            = 3
        max_count            = 5
        availability_zones   = [1, 2, 3]
      }
      network_profile = {
        network_plugin    = "azure"
        network_policy    = "azure"
        load_balancer_sku = "standard"
      }
      sku_tier     = "Standard"
      support_plan = "KubernetesOfficial"
    }
  }
}