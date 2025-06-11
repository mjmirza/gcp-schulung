resource "google_compute_network" "vpc_network" {
  name                    = "${var.org}-${var.env}-n8n-vpc"
  auto_create_subnetworks = false

  labels = {
    environment = var.env
    project     = var.org
  }
}

resource "google_compute_subnetwork" "subnetwork" {
  count            = length(var.subnetworks)
  name             = "${var.org}-${var.env}-n8n-subnet-${count.index}"
  ip_cidr_range    = element(var.subnetworks, count.index).cidr
  region           = var.region
  network          = google_compute_network.vpc_network.id

  labels = {
    environment = var.env
    project     = var.org
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.org}-${var.env}-allow-ssh"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges

  labels = {
    environment = var.env
    project     = var.org
  }
}

resource "google_compute_firewall" "allow_http" {
  name    = "${var.org}-${var.env}-allow-http"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  labels = {
    environment = var.env
    project     = var.org
  }
}

resource "google_compute_firewall" "allow_https" {
  name    = "${var.org}-${var.env}-allow-https"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]

  labels = {
    environment = var.env
    project     = var.org
  }
}