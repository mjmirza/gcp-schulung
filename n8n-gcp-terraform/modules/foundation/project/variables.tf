variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "project_name" {
  description = "The name of the Google Cloud project."
  type        = string
}

variable "billing_account" {
  description = "The billing account ID to associate with the project."
  type        = string
}

variable "org_id" {
  description = "The organization ID where the project will be created."
  type        = string
}

variable "location" {
  description = "The location for the resources."
  type        = string
  default     = "us-central1"
}

variable "enable_logging" {
  description = "Enable logging for the project."
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable monitoring for the project."
  type        = bool
  default     = true
}