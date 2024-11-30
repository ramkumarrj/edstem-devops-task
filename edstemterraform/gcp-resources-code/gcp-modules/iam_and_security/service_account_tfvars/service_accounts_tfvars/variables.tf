variable "project_id" {
  description = "The project ID for GCP"
  type        = string
}

variable "service_accounts_list_tfvars" {
  description = "List of service account configurations."
  type = list(object({
    account_name  = string
    display_name  = string
  }))
}
