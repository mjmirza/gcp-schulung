output "persistent_disk_names" {
  value = google_compute_disk.n8n_disk.*.name
}

output "persistent_disk_ids" {
  value = google_compute_disk.n8n_disk.*.id
}

output "persistent_disk_self_links" {
  value = google_compute_disk.n8n_disk.*.self_link
}