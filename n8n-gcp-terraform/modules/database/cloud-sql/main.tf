resource "google_sql_database_instance" "n8n_db" {
  name             = var.instance_name
  database_version = var.database_version
  region          = var.region

  settings {
    tier = var.tier

    ip_configuration {
      authorized_networks {
        name = "n8n-access"
        value = var.authorized_network
      }
      ipv4_enabled = true
    }

    backup_configuration {
      enabled = true
      start_time = var.backup_start_time
      location = var.backup_location
    }

    maintenance_window {
      day          = var.maintenance_day
      hour         = var.maintenance_hour
      update_track = var.update_track
    }
  }
}

resource "google_sql_database" "n8n_database" {
  name     = var.database_name
  instance = google_sql_database_instance.n8n_db.name
}

resource "google_sql_user" "n8n_user" {
  name     = var.database_user
  instance = google_sql_database_instance.n8n_db.name
  password = var.database_password
}

output "instance_connection_name" {
  value = google_sql_database_instance.n8n_db.connection_name
}

output "database_name" {
  value = google_sql_database.n8n_database.name
}

output "database_user" {
  value = google_sql_user.n8n_user.name
}