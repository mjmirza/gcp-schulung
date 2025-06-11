variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where resources will be created."
  type        = string
  default     = "us-central1-a"
}

variable "n8n_instance_name" {
  description = "The name of the n8n instance."
  type        = string
  default     = "n8n-instance"
}

variable "n8n_db_user" {
  description = "The database user for n8n."
  type        = string
  default     = "n8n_user"
}

variable "n8n_db_password" {
  description = "The password for the n8n database user."
  type        = string
  sensitive   = true
}

variable "n8n_db_name" {
  description = "The name of the n8n database."
  type        = string
  default     = "n8n_db"
}

variable "enable_logging" {
  description = "Enable logging for the n8n instance."
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable monitoring for the n8n instance."
  type        = bool
  default     = true
}

variable "vpc_network_name" {
  description = "The name of the VPC network."
  type        = string
  default     = "n8n-vpc"
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
  default     = "n8n-subnet"
}

variable "service_account_email" {
  description = "The email of the service account used by n8n."
  type        = string
}