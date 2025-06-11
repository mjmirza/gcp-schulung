variable "instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "database_name" {
  description = "The name of the database to create."
  type        = string
}

variable "user_name" {
  description = "The name of the SQL user to create."
  type        = string
}

variable "user_password" {
  description = "The password for the SQL user."
  type        = string
  sensitive   = true
}

variable "host" {
  description = "The host from which the user can connect."
  type        = string
  default     = "localhost"
}

variable "roles" {
  description = "The roles to assign to the SQL user."
  type        = list(string)
  default     = ["ROLE_DB_OWNER"]
}