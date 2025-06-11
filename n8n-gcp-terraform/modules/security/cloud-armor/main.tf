resource "google_compute_security_policy" "n8n_security_policy" {
  name     = "n8n-security-policy"
  project  = var.project_id

  rule {
    action = "deny-403"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["0.0.0.0/0"]
      }
    }
    description = "Deny all traffic by default"
  }

  rule {
    action = "allow"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.allowed_ip_ranges
      }
    }
    description = "Allow traffic from specified IP ranges"
  }

  # Enable logging for the security policy
  enable_logging = true
}

resource "google_compute_security_policy_rule" "n8n_security_policy_rule" {
  security_policy = google_compute_security_policy.n8n_security_policy.id
  action          = "allow"
  priority        = 1000

  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = var.allowed_ip_ranges
    }
  }

  description = "Allow traffic from specified IP ranges"
}

output "security_policy_id" {
  value = google_compute_security_policy.n8n_security_policy.id
}