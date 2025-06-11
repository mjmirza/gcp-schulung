# main.tf - Clean version with webhook URL fixes

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

provider "google" {
  project = var.project_id
  region  = var.region
}

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

# Get project information
data "google_project" "project" {
}

# Generate the expected Cloud Run URL (correct format)
locals {
  cloud_run_url = "https://n8n-service-${random_id.resource_suffix.hex}-${data.google_project.project.number}.${var.region}.run.app"
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

# Enable required APIs
resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_sql_api" {
  service = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

# Create Cloud SQL PostgreSQL instance
resource "google_sql_database_instance" "n8n_db" {
  name             = "n8n-db-instance-${random_id.resource_suffix.hex}"
  database_version = "POSTGRES_15"
  region           = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        value = "0.0.0.0/0"
        name  = "all-networks"
      }
    }
  }

  depends_on = [google_project_service.cloud_sql_api]
}

# Create database
resource "google_sql_database" "n8n_database" {
  name     = "n8n"
  instance = google_sql_database_instance.n8n_db.name
}

# Create database user
resource "google_sql_user" "n8n_user" {
  name     = "n8n"
  instance = google_sql_database_instance.n8n_db.name
  password = random_password.db_password.result
}

# Create service account for Cloud Run
resource "google_service_account" "n8n_service_account" {
  account_id   = "n8n-cloud-run-${random_id.resource_suffix.hex}"
  display_name = "n8n Cloud Run Service Account"
}

# Grant necessary permissions
resource "google_project_iam_member" "n8n_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.n8n_service_account.email}"
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

        # Critical webhook URL configuration
        env {
          name  = "WEBHOOK_URL"
          value = local.cloud_run_url
        }

        env {
          name  = "N8N_WEBHOOK_URL"
          value = local.cloud_run_url
        }

        env {
          name  = "N8N_EDITOR_BASE_URL"
          value = local.cloud_run_url
        }

        env {
          name  = "N8N_PROTOCOL"
          value = "https"
        }

        # CORS for embedding
        env {
          name  = "N8N_CORS_ORIGIN"
          value = "*"
        }

        resources {
          limits = {
            cpu    = "2000m"
            memory = "1Gi"
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "10"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.n8n_db.connection_name
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
    google_sql_user.n8n_user
  ]
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
  description = "URL of the n8n service"
  value       = google_cloud_run_service.n8n.status[0].url
}

output "webhook_base_url" {
  description = "Base URL for webhooks (should match actual Cloud Run URL)"
  value       = local.cloud_run_url
}
