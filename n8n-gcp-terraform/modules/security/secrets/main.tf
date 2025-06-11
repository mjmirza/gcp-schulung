resource "google_secret_manager_secret" "n8n_secret" {
  secret_id = var.secret_id
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "n8n_secret_version" {
  secret      = google_secret_manager_secret.n8n_secret.id
  secret_data = var.secret_data
}

output "secret_id" {
  value = google_secret_manager_secret.n8n_secret.id
}

output "secret_version" {
  value = google_secret_manager_secret_version.n8n_secret_version.version
}