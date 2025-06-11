variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "location" {
  description = "The location for the logging resources."
  type        = string
  default     = "us-central1"
}

variable "log_sink_name" {
  description = "The name of the log sink."
  type        = string
}

variable "destination" {
  description = "The destination for the log sink."
  type        = string
}

variable "filter" {
  description = "The filter for the log sink."
  type        = string
  default     = "severity>=ERROR"
}

variable "include_children" {
  description = "Whether to include children in the log sink."
  type        = bool
  default     = true
}