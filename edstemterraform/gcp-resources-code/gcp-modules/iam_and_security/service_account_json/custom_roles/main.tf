# ---------------------------- Roles Creation ---------------------------------
data "local_file" "role_files" {
  for_each = fileset("${path.module}/../../../iam_and_security/custom_roles/${var.custom_roles_location}", "*.yaml")
 
  filename = "${path.module}/../../../iam_and_security/custom_roles/${var.custom_roles_location}/${each.value}"
}

locals {
  role_definitions = [
    for file in data.local_file.role_files :
    yamldecode(file.content)
  ]

  roles_list = [
    for role in local.role_definitions :
    {
      role_id     = role.title
      title       = role.title
      description = role.description
      permissions = role.permissions
      stage       = role.stage
    }
  ]
}

resource "google_project_iam_custom_role" "custom_roles" {
  count = length(local.roles_list)

  project     = var.project_id
  role_id     = local.roles_list[count.index].role_id
  title       = local.roles_list[count.index].title
  description = local.roles_list[count.index].description
  permissions = local.roles_list[count.index].permissions
  stage       = local.roles_list[count.index].stage
}
