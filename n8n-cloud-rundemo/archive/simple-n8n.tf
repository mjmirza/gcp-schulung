# simple-n8n.tf
# Simple n8n service with SQLite (no external database required)

# Create a simple Cloud Run service with SQLite
resource "google_cloud_run_service" "n8n_simple" {
  name     = "n8n-simple-${random_id.resource_suffix.hex}"
  location = var.region

  template {
    spec {
      containers {
        image = "n8nio/n8n:latest"
        
        ports {
          container_port = 5678
        }

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
          name  = "N8N_LISTEN_ADDRESS"
          value = "0.0.0.0"
        }

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

        # Use SQLite (default) - no database configuration needed
        env {
          name  = "DB_TYPE"
          value = "sqlite"
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
        startup_probe {
          http_get {
            path = "/"
            port = 5678
          }
          initial_delay_seconds = 20
          timeout_seconds = 5
          period_seconds = 10
          failure_threshold = 3
        }

        liveness_probe {
          http_get {
            path = "/"
            port = 5678
          }
          initial_delay_seconds = 60
          timeout_seconds = 5
          period_seconds = 30
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