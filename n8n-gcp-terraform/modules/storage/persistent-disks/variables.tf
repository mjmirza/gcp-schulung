variable "disk_name" {
  description = "The name of the persistent disk."
  type        = string
}

variable "disk_size_gb" {
  description = "The size of the persistent disk in GB."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The type of the persistent disk (pd-standard, pd-ssd, pd-balanced)."
  type        = string
  default     = "pd-standard"
}

variable "zone" {
  description = "The zone where the persistent disk will be created."
  type        = string
}