output "service_account_emails" {
  value = [for sa in google_service_account.service_accounts_tfvars : sa.email]
}
