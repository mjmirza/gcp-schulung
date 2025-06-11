resource "google_compute_global_address" "n8n_lb_ip" {
  name = "n8n-lb-ip"
  ip_version = "IPV4"
}

resource "google_compute_ssl_certificate" "n8n_ssl_cert" {
  name = "n8n-ssl-cert"
  managed {
    domains = var.domains
  }
}

resource "google_compute_backend_service" "n8n_backend" {
  name = "n8n-backend"
  load_balancing_scheme = "EXTERNAL"
  health_checks = [google_compute_health_check.n8n_health_check.id]
  backend {
    group = google_compute_instance_group.n8n_instance_group.id
  }
}

resource "google_compute_health_check" "n8n_health_check" {
  name = "n8n-health-check"
  check_interval_sec = 10
  timeout_sec = 5
  healthy_threshold = 2
  unhealthy_threshold = 2
  http_health_check {
    port = 5678
    request_path = "/"
  }
}

resource "google_compute_url_map" "n8n_url_map" {
  name = "n8n-url-map"
  default_service = google_compute_backend_service.n8n_backend.id
}

resource "google_compute_target_https_proxy" "n8n_https_proxy" {
  name = "n8n-https-proxy"
  ssl_certificates = [google_compute_ssl_certificate.n8n_ssl_cert.id]
  url_map = google_compute_url_map.n8n_url_map.id
}

resource "google_compute_global_forwarding_rule" "n8n_forwarding_rule" {
  name = "n8n-forwarding-rule"
  target = google_compute_target_https_proxy.n8n_https_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.n8n_lb_ip.address
}

resource "google_compute_instance_group" "n8n_instance_group" {
  name = "n8n-instance-group"
  zone = var.zone
  instances = var.instance_ids
}

output "n8n_lb_ip" {
  value = google_compute_global_address.n8n_lb_ip.address
}

output "n8n_lb_url" {
  value = "https://${google_compute_global_address.n8n_lb_ip.address}"
}