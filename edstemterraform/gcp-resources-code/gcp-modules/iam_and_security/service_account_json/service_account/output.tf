output "service_account_ids" {
  description = "List of service account IDs"
  value       = google_service_account.service_accounts[*].account_id
}

output "service_account_emails" {
  description = "List of service account emails"
  value       = google_service_account.service_accounts[*].email
}
