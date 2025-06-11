resource "google_service_account" "n8n_service_account" {
  account_id   = var.service_account_id
  display_name = "n8n Service Account"
  project      = var.project_id

  depends_on = [google_project.project]
}

resource "google_project_iam_member" "n8n_service_account_roles" {
  for_each = var.service_account_roles

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.n8n_service_account.email}"
}

resource "google_project_iam_member" "n8n_service_account_impersonation" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "user:${var.impersonator_email}"
}

output "n8n_service_account_email" {
  value = google_service_account.n8n_service_account.email
}