variable "project_id" {
  description = "The project ID for GCP"
  type        = string
}

variable "service_accounts_list_json" {
  description = "Service Account Location"
  type        = string
}

variable "custom_roles_list_json" {
  description = "Custom Role Location"
  type        = string
}
