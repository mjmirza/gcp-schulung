variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "region" {
  description = "The region where the VPC will be created."
  type        = string
  default     = "us-central1"
}

variable "subnet_cidrs" {
  description = "A list of CIDR blocks for the subnets."
  type        = list(string)
}

variable "enable_private_google_access" {
  description = "Enable Private Google Access for the VPC."
  type        = bool
  default     = true
}

variable "firewall_rules" {
  description = "A list of firewall rules to apply to the VPC."
  type        = list(object({
    name    = string
    network = string
    allow   = list(object({
      protocol = string
      ports    = list(string)
    }))
    source_ranges = list(string)
  }))
  default = []
}