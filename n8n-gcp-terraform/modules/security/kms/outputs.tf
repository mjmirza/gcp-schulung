output "kms_key_id" {
  description = "The ID of the created KMS key."
  value       = google_kms_crypto_key.n8n_key.id
}

output "kms_key_ring_id" {
  description = "The ID of the KMS key ring."
  value       = google_kms_key_ring.n8n_key_ring.id
}

output "kms_project_id" {
  description = "The project ID where the KMS key is created."
  value       = var.project_id
}