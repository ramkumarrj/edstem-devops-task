
resource "google_project_iam_member" "service_account_roles" {
  for_each = toset(var.roles_list)

  project = var.project_id  
  role    = each.key
  member  = "serviceAccount:${var.service_account_email}"
}
