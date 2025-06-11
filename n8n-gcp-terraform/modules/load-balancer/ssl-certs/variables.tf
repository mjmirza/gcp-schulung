variable "ssl_certificate_name" {
  description = "The name of the SSL certificate."
  type        = string
}

variable "ssl_certificate_description" {
  description = "A description for the SSL certificate."
  type        = string
}

variable "ssl_certificate_private_key" {
  description = "The private key for the SSL certificate."
  type        = string
  sensitive   = true
}

variable "ssl_certificate_public_certificate" {
  description = "The public certificate for the SSL certificate."
  type        = string
}

variable "ssl_certificate_managed" {
  description = "Indicates if the SSL certificate is managed by Google."
  type        = bool
  default     = true
}