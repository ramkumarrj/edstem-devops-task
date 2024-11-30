data "local_file" "service_account_list" {
  filename = "${path.module}/../../../iam_and_security/role_bindings/service_accounts_list/projects/qa/list_of_service_account.json"
}

locals {
  service_accounts = jsondecode(data.local_file.service_account_list.content).service_accounts
}

data "local_file" "roles_list" {
  filename = "${path.module}/../../../iam_and_security/role_bindings/roles_list/projects/qa/roles_list.json" # Ensure this file exists
}

locals {
  role_ids = jsondecode(data.local_file.roles_list.content).roles_list
  combinations = [
    for sa in local.service_accounts : [
      for role in local.role_ids : {
        service_account = sa
        role_id        = role.role_name  
        is_custom      = role.is_custom   
      }
    ]
  ]
  flattened_combinations = flatten(local.combinations)
}

resource "google_project_iam_member" "custom_role_bindings" {
  for_each = { for idx, combination in local.flattened_combinations : "${combination.service_account}-${combination.role_id}" => combination }

  project = var.project_id
  role    = (each.value.is_custom ? "projects/${var.project_id}/roles/${each.value.role_id}" : each.value.role_id)
  member  = "serviceAccount:${each.value.service_account}"
}

output "iam_member_assignments" {
  value = { for r in google_project_iam_member.custom_role_bindings : r.id => {
    project = r.project
    role    = r.role
    member  = r.member
  }}
}
