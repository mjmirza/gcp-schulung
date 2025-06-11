# simple-n8n.tf - Final Simple n8n with SQLite and proper webhook URLs

# Generate the correct Cloud Run URL for simple service
locals {
  simple_cloud_run_url = "https://n8n-demo-${random_id.resource_suffix.hex}-${data.google_project.project.number}.${var.region}.run.app"
}

# Create a simple Cloud Run service with SQLite
resource "google_cloud_run_service" "n8n_simple" {
  name     = "n8n-demo-${random_id.resource_suffix.hex}"
  location = var.region

  template {
    spec {
      containers {
        image = "n8nio/n8n:latest"
        
        ports {
          container_port = 5678
        }

        # Basic n8n configuration
        env {
          name  = "N8N_BASIC_AUTH_ACTIVE"
          value = "false"
        }

        env {
          name  = "N8N_HOST"
          value = "0.0.0.0"
        }

        env {
          name  = "N8N_PORT"
          value = "5678"
        }

        env {
          name  = "N8N_PROTOCOL"
          value = "https"
        }

        # Critical webhook URL configuration
        env {
          name  = "WEBHOOK_URL"
          value = local.simple_cloud_run_url
        }

        env {
          name  = "N8N_WEBHOOK_URL"
          value = local.simple_cloud_run_url
        }

        env {
          name  = "N8N_EDITOR_BASE_URL"
          value = local.simple_cloud_run_url
        }

        # CORS and embedding configuration
        env {
          name  = "N8N_CORS_ORIGIN"
          value = "*"
        }

        env {
          name  = "N8N_SECURE_COOKIE"
          value = "false"
        }

        # Public API access
        env {
          name  = "N8N_PUBLIC_API_DISABLED"
          value = "false"
        }

        # Use SQLite (default) - no external database needed
        env {
          name  = "DB_TYPE"
          value = "sqlite"
        }

        # Additional configuration
        env {
          name  = "GENERIC_TIMEZONE"
          value = "Europe/Berlin"
        }

        env {
          name  = "NODE_ENV"
          value = "production"
        }

        env {
          name  = "N8N_LOG_LEVEL"
          value = "info"
        }

        env {
          name  = "N8N_DEFAULT_BINARY_DATA_MODE"
          value = "filesystem"
        }

        env {
          name  = "N8N_METRICS"
          value = "true"
        }

        # Allow all external requests
        env {
          name  = "N8N_BLOCK_ENV_ACCESS_IN_NODE"
          value = "false"
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
          requests = {
            cpu    = "500m"
            memory = "256Mi"
          }
        }

        # Health checks
        liveness_probe {
          http_get {
            path = "/"
            port = 5678
          }
          initial_delay_seconds = 180
          timeout_seconds = 10
          period_seconds = 60
          failure_threshold = 3
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "5"
        "autoscaling.knative.dev/minScale" = "0"
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/cpu-throttling" = "false"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  depends_on = [google_project_service.cloud_run_api]

  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations["run.googleapis.com/operation-id"],
    ]
  }
}

# Make the simple service publicly accessible
resource "google_cloud_run_service_iam_member" "n8n_simple_public" {
  service  = google_cloud_run_service.n8n_simple.name
  location = google_cloud_run_service.n8n_simple.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Output for simple n8n service
output "n8n_simple_url" {
  description = "URL of the simple n8n service (with SQLite)"
  value       = google_cloud_run_service.n8n_simple.status[0].url
}

output "simple_webhook_base_url" {
  description = "Base URL for simple service webhooks (should match actual Cloud Run URL)"
  value       = local.simple_cloud_run_url
}