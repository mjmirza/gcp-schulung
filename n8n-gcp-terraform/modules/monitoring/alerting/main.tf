resource "google_monitoring_alert_policy" "n8n_alert_policy" {
  display_name = "N8N Alert Policy"
  notification_channel = var.notification_channel_id
  enabled = true

  conditions {
    display_name = "N8N CPU Usage"
    condition_threshold {
      filter = "resource.type=\"gce_instance\" AND metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\""
      comparison = "COMPARISON_GT"
      threshold_value = var.cpu_threshold
      duration = "60s"
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  alert_strategy {
    notification_rate_limit {
      period = "60s"
      threshold = 5
    }
  }

  alert_strategy {
    notification_channel = var.notification_channel_id
  }
}

variable "notification_channel_id" {
  description = "The ID of the notification channel to use for alerts."
  type        = string
}

variable "cpu_threshold" {
  description = "The CPU usage threshold for triggering alerts."
  type        = number
  default     = 80
}