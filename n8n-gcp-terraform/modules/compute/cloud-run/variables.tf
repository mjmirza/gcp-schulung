variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region where the Cloud Run service will be deployed."
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "image" {
  description = "The container image to deploy on Cloud Run."
  type        = string
}

variable "memory" {
  description = "The amount of memory allocated to the Cloud Run service."
  type        = string
  default     = "256Mi"
}

variable "cpu" {
  description = "The number of CPUs allocated to the Cloud Run service."
  type        = string
  default     = "1"
}

variable "max_instances" {
  description = "The maximum number of instances for the Cloud Run service."
  type        = number
  default     = 10
}

variable "min_instances" {
  description = "The minimum number of instances for the Cloud Run service."
  type        = number
  default     = 0
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated invocations to the Cloud Run service."
  type        = bool
  default     = false
}

variable "env_vars" {
  description = "Environment variables to pass to the Cloud Run service."
  type        = map(string)
  default     = {}
}