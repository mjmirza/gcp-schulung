variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "cloud_armor_policy_name" {
  description = "The name of the Cloud Armor security policy."
  type        = string
}

variable "description" {
  description = "Description of the Cloud Armor policy."
  type        = string
  default     = "Cloud Armor policy for n8n deployment"
}

variable "rules" {
  description = "List of rules for the Cloud Armor policy."
  type        = list(object({
    action = string
    priority = number
    match = object({
      versionedExpr = string
      config = object({
        srcIpRanges = list(string)
      })
    })
  }))
}

variable "enabled" {
  description = "Whether the Cloud Armor policy is enabled."
  type        = bool
  default     = true
}