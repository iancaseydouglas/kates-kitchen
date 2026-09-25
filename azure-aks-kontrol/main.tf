resource "random_string" "default_nodepool_rotation" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

resource "random_pet" "default_nodepool_name" {
  length    = 1
  separator = ""
}

resource "azurerm_kubernetes_cluster" "this" {
  name                                = local.final_config.name
  location                            = local.final_config.location
  resource_group_name                 = local.final_config.resource_group_name
  dns_prefix                          = local.final_config.dns_prefix
  dns_prefix_private_cluster          = local.final_config.dns_prefix_private_cluster
  kubernetes_version                  = local.final_config.kubernetes_version
  sku_tier                            = local.final_config.sku_tier
  node_resource_group                 = local.final_config.node_resource_group
  azure_policy_enabled                = local.final_config.azure_policy_enabled
  disk_encryption_set_id              = local.final_config.disk_encryption_set_id
  edge_zone                           = local.final_config.edge_zone
  http_application_routing_enabled    = local.final_config.http_application_routing_enabled
  image_cleaner_enabled               = local.final_config.image_cleaner_enabled
  image_cleaner_interval_hours        = local.final_config.image_cleaner_interval_hours
  local_account_disabled              = local.final_config.local_account_disabled
  oidc_issuer_enabled                 = local.final_config.oidc_issuer_enabled
  open_service_mesh_enabled           = local.final_config.open_service_mesh_enabled
  private_cluster_enabled             = local.final_config.private_cluster_enabled
  private_cluster_public_fqdn_enabled = local.final_config.private_cluster_public_fqdn_enabled
  private_dns_zone_id                 = local.final_config.private_dns_zone_id
  role_based_access_control_enabled   = local.final_config.role_based_access_control_enabled
  run_command_enabled                 = local.final_config.run_command_enabled
  support_plan                        = local.final_config.support_plan
  workload_identity_enabled           = local.final_config.workload_identity_enabled
  cost_analysis_enabled               = lookup(local.final_config, "cost_analysis_enabled", false)

  identity {
    type = "SystemAssigned"
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = local.final_config.azure_active_directory_role_based_access_control != null ? [local.final_config.azure_active_directory_role_based_access_control] : []
    content {
      tenant_id              = azure_active_directory_role_based_access_control.value.tenant_id
      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
    }
  }

  dynamic "default_node_pool" {
    for_each = local.final_config.default_node_pool != null ? [local.final_config.default_node_pool] : []
    content {
      name                          = length("system${random_pet.default_nodepool_name.id}") > 12 ? substr("system${random_pet.default_nodepool_name.id}", 0, 12) : "system${random_pet.default_nodepool_name.id}"
      vm_size                       = default_node_pool.value.vm_size
      capacity_reservation_group_id = default_node_pool.value.capacity_reservation_group_id
      fips_enabled                  = default_node_pool.value.fips_enabled
      gpu_instance                  = default_node_pool.value.gpu_instance
      host_group_id                 = default_node_pool.value.host_group_id
      kubelet_disk_type             = default_node_pool.value.kubelet_disk_type
      max_count                     = default_node_pool.value.max_count
      max_pods                      = default_node_pool.value.max_pods
      min_count                     = default_node_pool.value.min_count
      node_count                    = default_node_pool.value.node_count
      auto_scaling_enabled          = default_node_pool.value.auto_scaling_enabled
      node_labels                   = default_node_pool.value.node_labels
      node_public_ip_prefix_id      = default_node_pool.value.node_public_ip_prefix_id
      only_critical_addons_enabled  = default_node_pool.value.only_critical_addons_enabled
      orchestrator_version          = default_node_pool.value.orchestrator_version
      os_disk_size_gb               = default_node_pool.value.os_disk_size_gb
      os_disk_type                  = default_node_pool.value.os_disk_type
      os_sku                        = default_node_pool.value.os_sku
      pod_subnet_id                 = default_node_pool.value.pod_subnet_id
      proximity_placement_group_id  = default_node_pool.value.proximity_placement_group_id
      scale_down_mode               = default_node_pool.value.scale_down_mode
      snapshot_id                   = default_node_pool.value.snapshot_id
      temporary_name_for_rotation   = substr("system${random_string.default_nodepool_rotation.result}", 0, 12)
      type                          = default_node_pool.value.type
      ultra_ssd_enabled             = default_node_pool.value.ultra_ssd_enabled
      vnet_subnet_id                = default_node_pool.value.vnet_subnet_id
      workload_runtime              = default_node_pool.value.workload_runtime
      zones                         = default_node_pool.value.zones
    }
  }

  dynamic "linux_profile" {
    for_each = local.final_config.linux_profile != null ? [local.final_config.linux_profile] : []
    content {
      admin_username = linux_profile.value.admin_username
      ssh_key {
        key_data = linux_profile.value.ssh_key
      }
    }
  }

  dynamic "network_profile" {
    for_each = local.final_config.network_profile != null ? [local.final_config.network_profile] : []
    content {
      network_plugin      = network_profile.value.network_plugin
      network_policy      = network_profile.value.network_policy
      network_mode        = network_profile.value.network_mode
      network_plugin_mode = network_profile.value.network_plugin_mode
      network_data_plane  = network_profile.value.network_data_plane
      outbound_type       = network_profile.value.outbound_type
      pod_cidr            = network_profile.value.pod_cidr
      pod_cidrs           = network_profile.value.pod_cidrs
      service_cidrs       = network_profile.value.service_cidrs
      service_cidr        = network_profile.value.service_cidr
      dns_service_ip      = network_profile.value.dns_service_ip
      ip_versions         = network_profile.value.ip_versions
      load_balancer_sku   = network_profile.value.load_balancer_sku
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = local.final_config.auto_scaler_profile != null ? [local.final_config.auto_scaler_profile] : []
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                         = auto_scaler_profile.value.expander
      max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
      scan_interval                    = auto_scaler_profile.value.scan_interval
      scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready               = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      empty_bulk_delete_max            = lookup(auto_scaler_profile.value, "empty_bulk_delete_max", null)
      skip_nodes_with_local_storage    = lookup(auto_scaler_profile.value, "skip_nodes_with_local_storage", null)
      skip_nodes_with_system_pods      = lookup(auto_scaler_profile.value, "skip_nodes_with_system_pods", null)
    }
  }

  dynamic "storage_profile" {
    for_each = local.final_config.storage_profile != null ? [local.final_config.storage_profile] : []
    content {
      blob_driver_enabled         = storage_profile.value.blob_driver_enabled
      disk_driver_enabled         = storage_profile.value.disk_driver_enabled
      file_driver_enabled         = storage_profile.value.file_driver_enabled
      snapshot_controller_enabled = lookup(storage_profile.value, "snapshot_controller_enabled", null)
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = local.final_config.workload_autoscaler_profile != null ? [local.final_config.workload_autoscaler_profile] : []
    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = local.final_config.ingress_application_gateway != null ? [local.final_config.ingress_application_gateway] : []
    content {
      gateway_id   = ingress_application_gateway.value.gateway_id
      gateway_name = ingress_application_gateway.value.gateway_name
      subnet_cidr  = ingress_application_gateway.value.subnet_cidr
      subnet_id    = ingress_application_gateway.value.subnet_id
    }
  }

  dynamic "api_server_access_profile" {
    for_each = local.final_config.api_server_access_profile != null ? [local.final_config.api_server_access_profile] : []
    content {
      authorized_ip_ranges = api_server_access_profile.value.authorized_ip_ranges
    }
  }

  dynamic "web_app_routing" {
    for_each = local.final_config.web_app_routing != null ? [local.final_config.web_app_routing] : []
    content {
      dns_zone_ids = web_app_routing.value.dns_zone_id
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = local.final_config.key_vault_secrets_provider != null ? [local.final_config.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  dynamic "key_management_service" {
    for_each = local.final_config.key_management_service != null ? [local.final_config.key_management_service] : []
    content {
      key_vault_key_id         = key_management_service.value.key_vault_key_id
      key_vault_network_access = key_management_service.value.key_vault_network_access
    }
  }

  dynamic "maintenance_window" {
    for_each = local.final_config.maintenance_window != null ? [local.final_config.maintenance_window] : []
    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed != null ? maintenance_window.value.allowed : []
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = maintenance_window.value.not_allowed != null ? maintenance_window.value.not_allowed : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = local.final_config.maintenance_window_auto_upgrade != null ? [local.final_config.maintenance_window_auto_upgrade] : []
    content {
      frequency   = maintenance_window_auto_upgrade.value.frequency
      interval    = maintenance_window_auto_upgrade.value.interval
      duration    = maintenance_window_auto_upgrade.value.duration
      day_of_week = maintenance_window_auto_upgrade.value.day_of_week
      week_index  = maintenance_window_auto_upgrade.value.week_index
      start_time  = maintenance_window_auto_upgrade.value.start_time
      utc_offset  = maintenance_window_auto_upgrade.value.utc_offset
      start_date  = maintenance_window_auto_upgrade.value.start_date

      dynamic "not_allowed" {
        for_each = maintenance_window_auto_upgrade.value.not_allowed != null ? maintenance_window_auto_upgrade.value.not_allowed : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "microsoft_defender" {
    for_each = local.final_config.microsoft_defender != null ? [local.final_config.microsoft_defender] : []
    content {
      log_analytics_workspace_id = lookup(microsoft_defender.value, "log_analytics_workspace_id", null)
    }
  }

  dynamic "monitor_metrics" {
    for_each = local.final_config.monitor_metrics != null ? [local.final_config.monitor_metrics] : []
    content {
      annotations_allowed = lookup(monitor_metrics.value, "annotations_allowed", null)
      labels_allowed      = lookup(monitor_metrics.value, "labels_allowed", null)
    }
  }

  dynamic "oms_agent" {
    for_each = local.final_config.oms_agent != null ? [local.final_config.oms_agent] : []
    content {
      log_analytics_workspace_id      = lookup(oms_agent.value, "log_analytics_workspace_id", null)
      msi_auth_for_monitoring_enabled = lookup(oms_agent.value, "msi_auth_for_monitoring_enabled", null)
    }
  }

  tags = local.final_config.tags

  lifecycle {
    ignore_changes = [
      kubernetes_version,
      default_node_pool[0].node_count,
      default_node_pool[0].orchestrator_version,
      default_node_pool[0].upgrade_settings,
      tags["created_by"],
      tags["created_time"]
    ]
  }
}