resource "google_service_account" "service_accounts_tfvars" {
  count = length(var.service_accounts_list_tfvars)

  project      = var.project_id
  account_id   = var.service_accounts_list_tfvars[count.index].account_name
  display_name = var.service_accounts_list_tfvars[count.index].display_name

  create_ignore_already_exists = true
}

