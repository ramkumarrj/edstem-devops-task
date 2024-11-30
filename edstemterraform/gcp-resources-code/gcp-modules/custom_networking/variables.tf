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
