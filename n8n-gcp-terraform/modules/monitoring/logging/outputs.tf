output "logging_sink_name" {
  value = google_logging_project_sink.n8n_logging_sink.name
}

output "logging_sink_id" {
  value = google_logging_project_sink.n8n_logging_sink.id
}

output "logging_sink_writer_identity" {
  value = google_logging_project_sink.n8n_logging_sink.writer_identity
}

output "logging_sink_destination" {
  value = google_logging_project_sink.n8n_logging_sink.destination
}