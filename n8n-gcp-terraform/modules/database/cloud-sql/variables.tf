variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region where the Cloud SQL instance will be created."
  type        = string
  default     = "us-central1"
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "database_version" {
  description = "The version of the database to use."
  type        = string
  default     = "POSTGRES_13"
}

variable "tier" {
  description = "The machine type for the Cloud SQL instance."
  type        = string
  default     = "db-f1-micro"
}

variable "root_password" {
  description = "The password for the root user."
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the database to create."
  type        = string
}

variable "enable_private_ip" {
  description = "Whether to enable private IP for the Cloud SQL instance."
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Whether to enable automated backups."
  type        = bool
  default     = true
}

variable "backup_window_start" {
  description = "The start time for the daily backup window."
  type        = string
  default     = "03:00"
}

variable "backup_window_end" {
  description = "The end time for the daily backup window."
  type        = string
  default     = "05:00"
}