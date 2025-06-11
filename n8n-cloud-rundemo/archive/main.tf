# terraform/main.tf

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "ai-poc-447214"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "europe-west3"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "europe-west3-a"
}

# Get project information
data "google_project" "project" {
}

# Enable required APIs
resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "cloud_sql_api" {
  service = "sqladmin.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "cloud_storage_api" {
  service = "storage.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

# Generate the expected Cloud Run URL
locals {
  cloud_run_url = "https://n8n-service-${random_id.resource_suffix.hex}-${var.region == "europe-west3" ? "ew" : substr(var.region, 0, 2)}.a.run.app"
}

# Generate random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Generate unique suffix for resources
resource "random_id" "resource_suffix" {
  byte_length = 4
}

# Create Cloud SQL PostgreSQL instance
resource "google_sql_database_instance" "n8n_db" {
  name             = "n8n-db-instance-${random_id.resource_suffix.hex}"
  database_version = "POSTGRES_15"
  region           = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "off"
    }

    backup_configuration {
      enabled = true
      start_time = "03:00"
    }

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        value = "0.0.0.0/0"
        name  = "all-networks"
      }
    }

    maintenance_window {
      day  = 7
      hour = 3
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [google_project_service.cloud_sql_api]
}

# Create database
resource "google_sql_database" "n8n_database" {
  name     = "n8n"
  instance = google_sql_database_instance.n8n_db.name
  charset  = "UTF8"
  collation = "en_US.UTF8"

  lifecycle {
    prevent_destroy = false
  }
}

# Create database user
resource "google_sql_user" "n8n_user" {
  name     = "n8n"
  instance = google_sql_database_instance.n8n_db.name
  password = random_password.db_password.result

  lifecycle {
    prevent_destroy = false
  }
}

# Create storage bucket for n8n files
resource "google_storage_bucket" "n8n_storage" {
  name          = "${var.project_id}-n8n-storage-${random_id.resource_suffix.hex}"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.cloud_storage_api]
}

# Create service account for Cloud Run
resource "google_service_account" "n8n_service_account" {
  account_id   = "n8n-cloud-run-${random_id.resource_suffix.hex}"
  display_name = "n8n Cloud Run Service Account"
  description  = "Service account for n8n Cloud Run service"
}

# Grant necessary permissions to service account
resource "google_project_iam_member" "n8n_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.n8n_service_account.email}"
}

resource "google_storage_bucket_iam_member" "n8n_storage_admin" {
  bucket = google_storage_bucket.n8n_storage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.n8n_service_account.email}"
}

# Create Cloud Run service
resource "google_cloud_run_service" "n8n" {
  name     = "n8n-service-${random_id.resource_suffix.hex}"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.n8n_service_account.email
      
      containers {
        image = "n8nio/n8n:latest"
        
        ports {
          container_port = 5678
        }

        env {
          name  = "DB_TYPE"
          value = "postgresdb"
        }

        env {
          name  = "DB_POSTGRESDB_HOST"
          value = google_sql_database_instance.n8n_db.ip_address.0.ip_address
        }

        env {
          name  = "DB_POSTGRESDB_PORT"
          value = "5432"
        }

        env {
          name  = "DB_POSTGRESDB_DATABASE"
          value = google_sql_database.n8n_database.name
        }

        env {
          name  = "DB_POSTGRESDB_USER"
          value = google_sql_user.n8n_user.name
        }

        env {
          name  = "DB_POSTGRESDB_PASSWORD"
          value = random_password.db_password.result
        }

        env {
          name  = "DB_POSTGRESDB_SCHEMA"
          value = "public"
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
          name  = "N8N_PROTOCOL"
          value = "https"
        }

        env {
          name  = "WEBHOOK_URL"
          value = local.cloud_run_url
        }

        env {
          name  = "N8N_EDITOR_BASE_URL"
          value = local.cloud_run_url
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

        # Storage configuration
        env {
          name  = "N8N_DEFAULT_BINARY_DATA_MODE"
          value = "filesystem"
        }

        resources {
          limits = {
            cpu    = "2000m"
            memory = "1Gi"
          }
          requests = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }

        # Health checks
        startup_probe {
          http_get {
            path = "/"
            port = 5678
          }
          initial_delay_seconds = 30
          timeout_seconds = 10
          period_seconds = 10
          failure_threshold = 6
        }

        liveness_probe {
          http_get {
            path = "/"
            port = 5678
          }
          initial_delay_seconds = 120
          timeout_seconds = 5
          period_seconds = 30
          failure_threshold = 3
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "10"
        "autoscaling.knative.dev/minScale" = "0"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.n8n_db.connection_name
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/cpu-throttling" = "false"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud_run_api,
    google_sql_database_instance.n8n_db,
    google_sql_database.n8n_database,
    google_sql_user.n8n_user,
    google_service_account.n8n_service_account
  ]

  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations["run.googleapis.com/operation-id"],
    ]
  }
}

# Make the service publicly accessible
resource "google_cloud_run_service_iam_member" "n8n_public_access" {
  service  = google_cloud_run_service.n8n.name
  location = google_cloud_run_service.n8n.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Outputs
output "n8n_url" {
  description = "URL of the main n8n service (with PostgreSQL)"
  value       = google_cloud_run_service.n8n.status[0].url
}

output "database_connection_name" {
  description = "Cloud SQL connection name"
  value       = google_sql_database_instance.n8n_db.connection_name
}

output "database_ip" {
  description = "Database IP address"
  value       = google_sql_database_instance.n8n_db.ip_address.0.ip_address
  sensitive   = true
}

output "storage_bucket_name" {
  description = "Storage bucket name"
  value       = google_storage_bucket.n8n_storage.name
}

output "database_password" {
  description = "Database password"
  value       = random_password.db_password.result
  sensitive   = true
}