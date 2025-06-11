variable "bucket_name" {
  description = "The name of the Cloud Storage bucket."
  type        = string
}

variable "location" {
  description = "The location where the bucket will be created."
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "The storage class for the bucket."
  type        = string
  default     = "STANDARD"
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket."
  type        = bool
  default     = false
}

variable "lifecycle_rule" {
  description = "Lifecycle rules for the bucket."
  type        = list(object({
    action = object({
      type = string
    })
    condition = object({
      age = number
    })
  }))
  default = []
}