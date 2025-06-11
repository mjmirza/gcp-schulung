output "secret_ids" {
  value = google_secret_manager_secret.secret.*.id
}

output "secret_names" {
  value = google_secret_manager_secret.secret.*.name
}

output "secret_versions" {
  value = google_secret_manager_secret_version.secret_version.*.version
}