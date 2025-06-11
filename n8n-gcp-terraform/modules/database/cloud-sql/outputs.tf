output "cloud_sql_instance_name" {
  value = google_sql_database_instance.n8n_instance.name
}

output "cloud_sql_instance_connection_name" {
  value = google_sql_database_instance.n8n_instance.connection_name
}

output "cloud_sql_database_name" {
  value = google_sql_database.n8n_database.name
}

output "cloud_sql_user_name" {
  value = google_sql_user.n8n_user.name
}