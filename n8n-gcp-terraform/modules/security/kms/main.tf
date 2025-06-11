resource "google_kms_key_ring" "n8n_key_ring" {
  name     = "n8n-key-ring"
  location = var.location

  labels = {
    environment = var.environment
    project     = var.project_id
  }
}

resource "google_kms_crypto_key" "n8n_crypto_key" {
  name     = "n8n-crypto-key"
  key_ring = google_kms_key_ring.n8n_key_ring.id

  purpose = "ENCRYPT_DECRYPT"

  labels = {
    environment = var.environment
    project     = var.project_id
  }

  rotation_period = "100000s" # Rotate every 100,000 seconds
  next_rotation_time = timestamp() + 100000
}

resource "google_kms_crypto_key_version" "n8n_crypto_key_version" {
  crypto_key = google_kms_crypto_key.n8n_crypto_key.id

  lifecycle {
    prevent_destroy = true
  }
}