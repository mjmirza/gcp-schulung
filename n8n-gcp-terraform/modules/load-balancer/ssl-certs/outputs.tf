output "ssl_certificate_name" {
  value = google_compute_managed_ssl_certificate.ssl_certificate.name
}

output "ssl_certificate_id" {
  value = google_compute_managed_ssl_certificate.ssl_certificate.id
}

output "ssl_certificate_self_link" {
  value = google_compute_managed_ssl_certificate.ssl_certificate.self_link
}