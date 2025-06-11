output "project_id" {
  value = google_project.project.project_id
}

output "project_number" {
  value = google_project.project.number
}

output "project_name" {
  value = google_project.project.name
}

output "billing_account" {
  value = google_project.project.billing_account
}

output "service_account_email" {
  value = google_service_account.n8n_service_account.email
}