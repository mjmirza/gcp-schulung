resource "google_compute_disk" "n8n_persistent_disk" {
  name    = "${var.project}-${var.environment}-n8n-persistent-disk"
  type    = var.disk_type
  zone    = var.zone
  size    = var.disk_size

  labels = {
    environment = var.environment
    project     = var.project
    app         = "n8n"
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "persistent_disk_id" {
  value = google_compute_disk.n8n_persistent_disk.id
}