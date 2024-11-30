resource "google_container_cluster" "kubernetes_clusters" {
  count = length(var.kubernetes_clusters)

  name                = "${var.custom_prefix}-${var.kubernetes_clusters[count.index].cluster_name}"
  description         = var.kubernetes_clusters[count.index].description
  project             = var.project_id
  location            = var.kubernetes_clusters[count.index].location
  deletion_protection = var.kubernetes_clusters[count.index].deletion_protection

  network            = "projects/${var.project_id}/global/networks/${var.custom_prefix}-vpc"
  subnetwork         = "projects/${var.project_id}/regions/${var.kubernetes_clusters[count.index].subnet_region}/subnetworks/${var.custom_prefix}-${var.kubernetes_clusters[count.index].subnet_name}"
  node_version       = var.kubernetes_clusters[count.index].kubernetes_version
  min_master_version = var.kubernetes_clusters[count.index].kubernetes_version
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  networking_mode    = "VPC_NATIVE"
 
  private_cluster_config {
    enable_private_endpoint     = false
    enable_private_nodes        = var.kubernetes_clusters[count.index].private_cluster_config.enable_private_nodes
    master_ipv4_cidr_block      = var.kubernetes_clusters[count.index].private_cluster_config.master_ipv4_cidr_block 
    private_endpoint_subnetwork = null
    master_global_access_config {
      enabled = true
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  
  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "global"
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  maintenance_policy {
    recurring_window {
      start_time = var.kubernetes_clusters[count.index].maintenance_policy.recurring_window.start_time
      end_time   = var.kubernetes_clusters[count.index].maintenance_policy.recurring_window.end_time
      recurrence = var.kubernetes_clusters[count.index].maintenance_policy.recurring_window.recurrence
    }
  }  

  addons_config {
    dns_cache_config {
      enabled = false
    }
    horizontal_pod_autoscaling {
      disabled = true
    }
    http_load_balancing {
      disabled = false
    }
  }  

  node_pool {
    name              = "default-pool"
    node_count        = var.kubernetes_clusters[count.index].node_count
    max_pods_per_node = var.kubernetes_clusters[count.index].max_pods
    node_locations    = var.kubernetes_clusters[count.index].node_locations
    version           = var.kubernetes_clusters[count.index].kubernetes_version
    autoscaling {
      location_policy      = var.kubernetes_clusters[count.index].autoscaling.location_policy
      max_node_count       = var.kubernetes_clusters[count.index].autoscaling.max_node_count
      min_node_count       = var.kubernetes_clusters[count.index].autoscaling.min_node_count
      total_max_node_count = 0
      total_min_node_count = 0
    }
    management {
      auto_repair  = true
      auto_upgrade = true
    }

    node_config {
      boot_disk_kms_key           = null
      disk_size_gb                = var.kubernetes_clusters[count.index].node_hdd_size
      disk_type                   = var.kubernetes_clusters[count.index].node_disk_type
      enable_confidential_storage = false
      image_type                  = var.kubernetes_clusters[count.index].node_image_type
      labels                      = {}
      local_ssd_count             = 0
      logging_variant             = "DEFAULT"
      machine_type                = var.kubernetes_clusters[count.index].machine_type
      metadata                    = var.kubernetes_clusters[count.index].metadata

      min_cpu_platform      = null
      node_group            = null     
      preemptible           = false
      resource_labels       = {}
      resource_manager_tags = {}
      spot                  = var.kubernetes_clusters[count.index].spot
      tags                  = var.kubernetes_clusters[count.index].tags
      service_account       = var.kubernetes_clusters[count.index].service_account   
      shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
      }
    }
    upgrade_settings {
      max_surge       = 1
      max_unavailable = 0
      strategy        = "SURGE"
    }
  }
}
