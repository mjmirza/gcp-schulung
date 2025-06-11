variable "alerting_policy_name" {
  description = "The name of the alerting policy."
  type        = string
}

variable "notification_channel_ids" {
  description = "A list of notification channel IDs to use for the alerting policy."
  type        = list(string)
}

variable "alerting_threshold" {
  description = "The threshold value for triggering the alert."
  type        = number
}

variable "alerting_duration" {
  description = "The duration for which the threshold must be exceeded before triggering the alert."
  type        = string
}

variable "alerting_severity" {
  description = "The severity level of the alert."
  type        = string
  default     = "DEFAULT"
}

variable "alerting_description" {
  description = "A description of the alerting policy."
  type        = string
  default     = "Alerting policy for monitoring n8n."
}