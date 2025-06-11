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
    project     = var.project_name
  }

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "n8n_bucket_member" {
  for_each = var.bucket_iam_members

  bucket = google_storage_bucket.n8n_bucket.name
  role   = each.value.role
  member = each.value.member
}