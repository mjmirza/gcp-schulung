variable "secret_name" {
  description = "The name of the secret to be created in Google Secret Manager."
  type        = string
}

variable "secret_data" {
  description = "The data to be stored in the secret."
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Cloud project where the secret will be created."
  type        = string
}

variable "location" {
  description = "The location where the secret will be stored."
  type        = string
  default     = "global"
}