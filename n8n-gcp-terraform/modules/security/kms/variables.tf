variable "project_id" {
  description = "The ID of the Google Cloud project where KMS will be created."
  type        = string
}

variable "location" {
  description = "The location (region) where the KMS key ring and keys will be created."
  type        = string
}

variable "key_ring_name" {
  description = "The name of the key ring to create."
  type        = string
}

variable "crypto_key_name" {
  description = "The name of the cryptographic key to create."
  type        = string
}

variable "rotation_period" {
  description = "The period for automatic key rotation, in seconds."
  type        = string
  default     = "31536000" # 1 year
}

variable "description" {
  description = "A description for the cryptographic key."
  type        = string
  default     = "Key for n8n encryption"
}