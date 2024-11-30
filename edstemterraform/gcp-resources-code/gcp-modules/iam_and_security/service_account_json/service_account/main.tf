# First Edition Date - 11-SEP-2024
data "local_file" "service_accounts_file" {
  filename = "${path.module}/../../../iam_and_security/service_accounts/${var.service_accounts_name_json}"
}

locals {
  service_accounts = jsondecode(data.local_file.service_accounts_file.content).service_accounts
}

resource "google_service_account" "service_accounts" {
  count = length(local.service_accounts)

  project                      = var.project_id
  account_id                   = local.service_accounts[count.index]
  display_name                 = local.service_accounts[count.index]
  create_ignore_already_exists = true
}
