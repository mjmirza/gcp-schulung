output "https_lb_ip" {
  value = google_compute_global_address.n8n_lb_ip.address
}

output "https_lb_url" {
  value = "https://${google_compute_global_address.n8n_lb_ip.address}"
}

output "https_lb_backend_service" {
  value = google_compute_backend_service.n8n_backend_service.id
}

output "https_lb_health_check" {
  value = google_compute_http_health_check.n8n_health_check.id
}