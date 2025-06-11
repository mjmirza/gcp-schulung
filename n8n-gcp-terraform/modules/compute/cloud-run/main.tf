resource "google_cloud_run_service" "n8n" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = var.container_image

        ports {
          container_port = 5678
        }

        env {
          name  = "DB_TYPE"
          value = var.db_type
        }

        env {
          name  = "DB_HOST"
          value = google_cloud_sql_database_instance.n8n_db.private_ip
        }

        env {
          name  = "DB_PORT"
          value = var.db_port
        }

        env {
          name  = "DB_USER"
          value = var.db_user
        }

        env {
          name  = "DB_PASSWORD"
          value = google_secret_manager_secret_version.n8n_db_password.secret_data
        }

        resources {
          limits {
            memory = var.memory_limit
            cpu    = var.cpu_limit
          }
        }
      }

      service_account_name = google_service_account.n8n_service_account.email

      traffic {
        percent         = 100
        revision_name   = google_cloud_run_service.n8n.latest_revision_name
        latest_revision = true
      }
    }
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service = google_cloud_run_service.n8n.name
  location = google_cloud_run_service.n8n.location
  role    = "roles/run.invoker"
  member  = "allUsers"
}

resource "google_secret_manager_secret" "n8n_db_password" {
  secret_id = "${var.service_name}-db-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "n8n_db_password" {
  secret      = google_secret_manager_secret.n8n_db_password.id
  secret_data = var.db_password
}

output "n8n_url" {
  value = google_cloud_run_service.n8n.status[0].url
}