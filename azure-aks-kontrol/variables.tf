variable "aks_config" {
  description = "Comprehensive configuration for AKS cluster"
  type = object({
    name                                = string
    location                            = string
    resource_group_name                 = string
    dns_prefix                          = optional(string)
    dns_prefix_private_cluster          = optional(string)
    kubernetes_version                  = optional(string)
    automatic_channel_upgrade           = optional(string)
    sku_tier                            = optional(string)
    support_plan                        = optional(string)
    node_resource_group                 = optional(string)
    azure_policy_enabled                = optional(bool)
    disk_encryption_set_id              = optional(string)
    edge_zone                           = optional(string)
    http_application_routing_enabled    = optional(bool)
    image_cleaner_enabled               = optional(bool)
    image_cleaner_interval_hours        = optional(number)
    local_account_disabled              = optional(bool)
    node_os_channel_upgrade             = optional(string)
    oidc_issuer_enabled                 = optional(bool)
    open_service_mesh_enabled           = optional(bool)
    private_cluster_enabled             = optional(bool)
    private_cluster_public_fqdn_enabled = optional(bool)
    private_dns_zone_id                 = optional(string)
    role_based_access_control_enabled   = optional(bool)
    run_command_enabled                 = optional(bool)
    workload_identity_enabled           = optional(bool)
    environment                         = optional(string)
    project                             = optional(string)
    tags                                = optional(map(string))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    service_principal = optional(object({
      client_id     = string
      client_secret = string
    }))

    azure_active_directory_role_based_access_control = optional(object({
      managed                = optional(bool)
      tenant_id              = optional(string)
      admin_group_object_ids = optional(list(string))
      azure_rbac_enabled     = optional(bool)
    }))

    default_node_pool = object({
      name                          = optional(string)
      vm_size                       = optional(string)
      capacity_reservation_group_id = optional(string)
      custom_ca_trust_enabled       = optional(bool)
      auto_scaling_enabled          = optional(bool)
      enable_host_encryption        = optional(bool)
      enable_node_public_ip         = optional(bool)
      fips_enabled                  = optional(bool)
      gpu_instance                  = optional(string)
      host_group_id                 = optional(string)
      kubelet_disk_type             = optional(string)
      max_count                     = optional(number)
      max_pods                      = optional(number)
      message_of_the_day            = optional(string)
      min_count                     = optional(number)
      node_count                    = optional(number)
      node_labels                   = optional(map(string))
      node_public_ip_prefix_id      = optional(string)
      node_taints                   = optional(list(string))
      only_critical_addons_enabled  = optional(bool)
      orchestrator_version          = optional(string)
      os_disk_size_gb               = optional(number)
      os_disk_type                  = optional(string)
      os_sku                        = optional(string)
      pod_subnet_id                 = optional(string)
      proximity_placement_group_id  = optional(string)
      scale_down_mode               = optional(string)
      snapshot_id                   = optional(string)
      temporary_name_for_rotation   = optional(string)
      type                          = optional(string)
      ultra_ssd_enabled             = optional(bool)
      vnet_subnet_id                = optional(string)
      workload_runtime              = optional(string)
      zones                         = optional(list(string))
    })

    linux_profile = optional(object({
      admin_username = string
      ssh_key        = string
    }))

    network_profile = optional(object({
      network_plugin      = string
      network_policy      = optional(string)
      network_mode        = optional(string)
      network_plugin_mode = optional(string)
      network_data_plane  = optional(string)
      outbound_type       = optional(string)
      pod_cidr            = optional(string)
      pod_cidrs           = optional(list(string))
      service_cidr        = optional(string)
      service_cidrs       = optional(list(string))
      dns_service_ip      = optional(string)
      ip_versions         = optional(list(string))
      load_balancer_sku   = optional(string)
    }))

    auto_scaler_profile = optional(object({
      balance_similar_node_groups      = optional(bool)
      expander                         = optional(string)
      max_graceful_termination_sec     = optional(number)
      max_node_provisioning_time       = optional(string)
      max_unready_nodes                = optional(number)
      max_unready_percentage           = optional(number)
      new_pod_scale_up_delay           = optional(string)
      scale_down_delay_after_add       = optional(string)
      scale_down_delay_after_delete    = optional(string)
      scale_down_delay_after_failure   = optional(string)
      scan_interval                    = optional(string)
      scale_down_unneeded              = optional(string)
      scale_down_unready               = optional(string)
      scale_down_utilization_threshold = optional(number)
      empty_bulk_delete_max            = optional(number)
      skip_nodes_with_local_storage    = optional(bool)
      skip_nodes_with_system_pods      = optional(bool)
    }))

    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool)
      disk_driver_enabled         = optional(bool)
      disk_driver_version         = optional(string)
      file_driver_enabled         = optional(bool)
      snapshot_controller_enabled = optional(bool)
    }))

    workload_autoscaler_profile = optional(object({
      keda_enabled                    = optional(bool)
      vertical_pod_autoscaler_enabled = optional(bool)
    }))

    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_cidr  = optional(string)
      subnet_id    = optional(string)
    }))

    api_server_access_profile = optional(object({
      authorized_ip_ranges     = optional(list(string))
      subnet_id                = optional(string)
      vnet_integration_enabled = optional(bool)
    }))

    web_app_routing = optional(object({
      dns_zone_id = string
    }))

    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool)
      secret_rotation_interval = optional(string)
    }))

    key_management_service = optional(object({
      key_vault_key_id         = string
      key_vault_network_access = optional(string)
    }))

    maintenance_window = optional(object({
      allowed = optional(list(object({
        day   = string
        hours = list(number)
      })))
      not_allowed = optional(list(object({
        end   = string
        start = string
      })))
    }))

    maintenance_window_auto_upgrade = optional(object({
      frequency   = string
      interval    = number
      duration    = string
      day_of_week = optional(string)
      week_index  = optional(string)
      start_time  = optional(string)
      utc_offset  = optional(string)
      start_date  = optional(string)
      not_allowed = optional(list(object({
        end   = string
        start = string
      })))
    }))

    microsoft_defender = optional(object({
      log_analytics_workspace_id = string
    }))

    oms_agent = optional(object({
      log_analytics_workspace_id      = string
      msi_auth_for_monitoring_enabled = optional(bool)
    }))
  })
}

variable "cluster_profile" {
  description = "The name of the base cluster profile to use"
  type        = string
  default     = "standard"
}

variable "cluster_features" {
  description = "List of feature sets to apply on top of the base cluster_profile"
  type        = any
  default     = ["weeknight_maintenance"]
}