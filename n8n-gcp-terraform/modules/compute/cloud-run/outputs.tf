output "cloud_run_url" {
  value = google_cloud_run_service.n8n_service.status[0].url
}

output "cloud_run_service_name" {
  value = google_cloud_run_service.n8n_service.name
}

output "cloud_run_service_id" {
  value = google_cloud_run_service.n8n_service.id
}

output "cloud_run_service_region" {
  value = google_cloud_run_service.n8n_service.region
}