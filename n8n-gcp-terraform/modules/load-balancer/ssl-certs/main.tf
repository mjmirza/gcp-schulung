resource "google_compute_managed_ssl_certificate" "n8n_ssl_cert" {
  name = var.ssl_cert_name
  description = "Managed SSL certificate for n8n"
  
  managed {
    domains = var.domains
  }
}

output "ssl_cert_id" {
  value = google_compute_managed_ssl_certificate.n8n_ssl_cert.id
}