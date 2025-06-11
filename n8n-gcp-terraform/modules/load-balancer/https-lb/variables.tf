variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region where the load balancer will be deployed."
  type        = string
  default     = "us-central1"
}

variable "frontend_ip" {
  description = "The IP address for the frontend of the load balancer."
  type        = string
}

variable "backend_service_name" {
  description = "The name of the backend service for the load balancer."
  type        = string
}

variable "health_check_name" {
  description = "The name of the health check for the backend service."
  type        = string
}

variable "session_affinity" {
  description = "Session affinity for the load balancer."
  type        = string
  default     = "NONE"
}

variable "timeout_sec" {
  description = "Timeout for the backend service in seconds."
  type        = number
  default     = 10
}

variable "max_connections" {
  description = "Maximum number of connections to the backend service."
  type        = number
  default     = 1000
}

variable "enable_cdn" {
  description = "Enable Cloud CDN for the load balancer."
  type        = bool
  default     = false
}