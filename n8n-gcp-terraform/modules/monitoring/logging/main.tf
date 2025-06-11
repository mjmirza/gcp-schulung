resource "google_logging_project_sink" "n8n_logging" {
  name        = "n8n-logging-sink"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${var.dataset_id}"
  filter      = "resource.type=\"gce_instance\""

  depends_on = [google_project_service.logging]
}

resource "google_logging_project_exclusion" "n8n_exclusion" {
  name   = "n8n-exclusion"
  filter = "resource.type=\"gce_instance\" AND severity=\"DEBUG\""

  depends_on = [google_logging_project_sink.n8n_logging]
}

resource "google_project_service" "logging" {
  project = var.project_id
  service = "logging.googleapis.com"
}

output "logging_sink_id" {
  value = google_logging_project_sink.n8n_logging.id
}

output "logging_exclusion_id" {
  value = google_logging_project_exclusion.n8n_exclusion.id
}