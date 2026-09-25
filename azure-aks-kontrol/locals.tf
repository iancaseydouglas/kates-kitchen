locals {
  default_config = {
    kubernetes_version = "1.29"
    # sku_tier                         = "Free"
    automatic_channel_upgrade        = "stable"
    azure_policy_enabled             = false
    http_application_routing_enabled = false
    private_cluster_enabled          = false
    run_command_enabled              = true

    default_node_pool = {
      name                 = "system"
      vm_size              = local.vms.medium
      os_sku               = "AzureLinux"
      auto_scaling_enabled = true
      min_count            = 2
      max_count            = 5
      node_count           = 3
    }

    # default_node_pool = {
    #   name            = "default"
    #   node_count      = 2
    #   vm_size         = "Standard_DS2_v2"
    #   os_disk_size_gb = 30
    #   os_disk_type    = "Managed"
    #   type            = "VirtualMachineScaleSets"
    #   os_sku          = "AzureLinux"
    # }

    network_profile = {
      network_plugin = "azure"
      outbound_type  = "loadBalancer"
    }

    identity = {
      type = "SystemAssigned"
    }

    auto_scaler_profile = {
      expander                   = "random"
      scale_down_delay_after_add = "10m"
      scale_down_unneeded        = "10m"
    }

    storage_profile = {
      blob_driver_enabled = false
      disk_driver_enabled = true
      file_driver_enabled = true
    }

    tags = {}
  }
}

# 
locals {
  # Start with the default configuration
  base_config = local.default_config

  # Apply the selected cluster profile
  profile_config = var.cluster_profile != null ? provider::deepmerge::mergo(local.base_config, local.cluster_profiles[var.cluster_profile]) : local.base_config

  # Apply selected feature sets
  feature_config = provider::deepmerge::mergo(
    local.profile_config,
    [for feature in var.cluster_features : lookup(local.feature_sets, feature, {})]...
  )

  # Finally, apply user-provided configuration
  final_config = provider::deepmerge::mergo(local.feature_config, var.aks_config, "no_null_override")

  # Generate a unique suffix for the cluster name
  cluster_suffix = random_string.cluster_suffix.result
  full_cluster_name = "${local.final_config.name}-${local.cluster_suffix}"
}



resource "random_string" "cluster_suffix" {
  length  = 8
  special = false
  upper   = false
}