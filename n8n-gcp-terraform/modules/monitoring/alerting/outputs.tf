output "alerting_policy_ids" {
  description = "The IDs of the created alerting policies."
  value       = google_monitoring_alert_policy.alerting_policy.*.id
}

output "notification_channel_ids" {
  description = "The IDs of the notification channels used in alerting policies."
  value       = google_monitoring_notification_channel.notification_channel.*.id
}