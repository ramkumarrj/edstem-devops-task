variable "project_id" {
  description = "The project ID for GCP"
  type        = string
}

variable "roles_list" {
  type = list(string)
}

variable "service_account_email" {
  type = string
}
