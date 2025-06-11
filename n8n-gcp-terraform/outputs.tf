output "n8n_instance_url" {
  value = "https://${google_cloud_run_service.n8n_service.name}-${var.region}.run.app"
}

output "n8n_service_account_email" {
  value = google_service_account.n8n_service_account.email
}

output "cloud_sql_instance_connection_name" {
  value = google_sql_database_instance.n8n_db.connection_name
}

output "cloud_storage_bucket_name" {
  value = google_storage_bucket.n8n_bucket.name
}

output "load_balancer_ip" {
  value = google_compute_global_address.n8n_lb.address
}