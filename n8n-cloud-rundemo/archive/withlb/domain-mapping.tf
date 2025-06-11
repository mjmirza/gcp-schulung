# domain-mapping.tf - Custom domain with Load Balancer for Cloud Run

# Enable additional required APIs
resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "certificatemanager_api" {
  service = "certificatemanager.googleapis.com"
  disable_on_destroy = false
}

# Create a global IP address
resource "google_compute_global_address" "n8n_ip" {
  name = "n8n-global-ip-${random_id.resource_suffix.hex}"
}

# Create SSL certificate for the custom domain
resource "google_compute_managed_ssl_certificate" "n8n_ssl_cert" {
  name = "n8n-ssl-cert-${random_id.resource_suffix.hex}"

  managed {
    domains = ["gcp.try.jetzt"]
  }
}

# Create a serverless NEG (Network Endpoint Group) for Cloud Run
resource "google_compute_region_network_endpoint_group" "n8n_neg" {
  name                  = "n8n-neg-${random_id.resource_suffix.hex}"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = google_cloud_run_service.n8n_simple.name
  }
}

# Create backend service
resource "google_compute_backend_service" "n8n_backend" {
  name                            = "n8n-backend-${random_id.resource_suffix.hex}"
  description                     = "Backend service for n8n"
  protocol                        = "HTTP"
  port_name                       = "http"
  timeout_sec                     = 30
  connection_draining_timeout_sec = 10

  backend {
    group = google_compute_region_network_endpoint_group.n8n_neg.id
  }

  log_config {
    enable = true
  }
}

# Create URL map
resource "google_compute_url_map" "n8n_url_map" {
  name            = "n8n-url-map-${random_id.resource_suffix.hex}"
  description     = "URL map for n8n custom domain"
  default_service = google_compute_backend_service.n8n_backend.id
}

# Create HTTPS proxy
resource "google_compute_target_https_proxy" "n8n_https_proxy" {
  name             = "n8n-https-proxy-${random_id.resource_suffix.hex}"
  url_map          = google_compute_url_map.n8n_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.n8n_ssl_cert.id]
}

# Create HTTP proxy for redirect
resource "google_compute_target_http_proxy" "n8n_http_proxy" {
  name    = "n8n-http-proxy-${random_id.resource_suffix.hex}"
  url_map = google_compute_url_map.n8n_redirect_map.id
}

# Create URL map for HTTP to HTTPS redirect
resource "google_compute_url_map" "n8n_redirect_map" {
  name = "n8n-redirect-map-${random_id.resource_suffix.hex}"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query           = false
  }
}

# Create global forwarding rule for HTTPS
resource "google_compute_global_forwarding_rule" "n8n_https_forwarding_rule" {
  name                  = "n8n-https-forwarding-rule-${random_id.resource_suffix.hex}"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.n8n_https_proxy.id
  ip_address            = google_compute_global_address.n8n_ip.id
}

# Create global forwarding rule for HTTP (redirect to HTTPS)
resource "google_compute_global_forwarding_rule" "n8n_http_forwarding_rule" {
  name                  = "n8n-http-forwarding-rule-${random_id.resource_suffix.hex}"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.n8n_http_proxy.id
  ip_address            = google_compute_global_address.n8n_ip.id
}

# Update the simple n8n service to use the custom domain in webhook URLs
locals {
  custom_domain_url = "https://gcp.try.jetzt"
}