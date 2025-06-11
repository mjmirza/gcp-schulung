resource "google_compute_instance" "n8n_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnetwork_name

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = file("startup-script.sh")

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  labels = {
    environment = var.environment
    app         = "n8n"
  }

  tags = var.instance_tags

  lifecycle {
    prevent_destroy = false
  }
}

output "n8n_instance_ip" {
  value = google_compute_instance.n8n_instance.network_interface[0].access_config[0].nat_ip
}