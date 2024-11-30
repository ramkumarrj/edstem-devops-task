
variable "project_id" {
  description = "The project ID for GCP"
  type        = string
}

variable "custom_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name                     = string
    region                   = string
    cidr_range               = string
    private_ip_google_access = bool
    purpose                  = string
  }))
}

variable "firewalls" {
  description = "List of firewall rules to create"
  type = list(object({
    name      = string
    direction = string
    priority  = number
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
    source_ranges = list(string)
  }))
}


variable "service_accounts_list_tfvars" {
  description = "List of service account configurations."
  type = list(object({
    account_name  = string
    display_name  = string
  }))
}

variable "gke_service_account" {
  type = string
}

variable "gke_service_account_roles" {
  type = list(string)
}

variable "kubernetes_clusters" {
  description = "List of GKE clusters to create"
  type = list(object({
    cluster_name        = string    
    description         = string
    metadata            = map(string)   
    location            = string
    deletion_protection = bool
    subnet_name         = string
    subnet_region       = string
    kubernetes_version  = string
    ip_allocation_policy = object({
      cluster_ipv4_cidr_block  = string
      services_ipv4_cidr_block = string    
    })   
    private_cluster_config = object({
		  enable_private_nodes   = bool
		  master_ipv4_cidr_block = string    
    })      
    node_count          = number
    max_pods            = number
    node_locations      = list(string)
    autoscaling = object({
      location_policy = string
      max_node_count = number
      min_node_count = number      
    })
    maintenance_policy = object({
        recurring_window = object({
          start_time = string
          end_time   = string
          recurrence = string
        })
      })
    node_hdd_size       = number
    node_disk_type      = string
    node_image_type     = string
    machine_type        = string
    service_account     = string
    spot                = bool
    tags                = list(string)
  }))
}