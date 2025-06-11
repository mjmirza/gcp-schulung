resource "google_storage_bucket" "n8n_bucket" {
  name     = var.bucket_name
  location = var.bucket_location

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  labels = {
    environment = var.environment
    project     = var.project_id
  }
}

output "bucket_name" {
  value = google_storage_bucket.n8n_bucket.name
}

output "bucket_location" {
  value = google_storage_bucket.n8n_bucket.location
}