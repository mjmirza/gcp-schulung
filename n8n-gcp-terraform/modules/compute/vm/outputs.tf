output "vm_instance_name" {
  value = google_compute_instance.n8n_instance.name
}

output "vm_instance_ip" {
  value = google_compute_instance.n8n_instance.network_interface[0].access_config[0].nat_ip
}

output "vm_instance_zone" {
  value = google_compute_instance.n8n_instance.zone
}

output "vm_instance_self_link" {
  value = google_compute_instance.n8n_instance.self_link
}