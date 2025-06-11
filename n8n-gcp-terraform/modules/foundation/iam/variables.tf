variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "service_account_name" {
  description = "The name of the service account to be created."
  type        = string
}

variable "service_account_display_name" {
  description = "The display name for the service account."
  type        = string
}

variable "roles" {
  description = "A list of IAM roles to assign to the service account."
  type        = list(string)
}

variable "service_account_email" {
  description = "The email of the service account."
  type        = string
  default     = ""
}

variable "service_account_description" {
  description = "A description for the service account."
  type        = string
  default     = ""
}