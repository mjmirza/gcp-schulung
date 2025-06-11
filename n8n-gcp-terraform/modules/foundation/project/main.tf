resource "google_project" "n8n_project" {
  name       = var.project_name
  project_id = var.project_id
  org_id     = var.org_id
  billing_account = var.billing_account

  labels = {
    environment = var.environment
    application = "n8n"
  }
}

resource "google_project_service" "enabled_services" {
  for_each = toset(var.enabled_services)

  project = google_project.n8n_project.project_id
  service = each.key
}

resource "google_project_iam_member" "project_iam" {
  for_each = var.iam_roles

  project = google_project.n8n_project.project_id
  role    = each.key
  member  = each.value
}

resource "google_project_budget" "budget" {
  project = google_project.n8n_project.project_id
  display_name = "${var.project_name} Budget"
  amount = var.budget_amount

  notifications {
    threshold_percent = var.notification_threshold
    pubsub_topic = google_pubsub_topic.budget_notifications.id
  }
}

resource "google_pubsub_topic" "budget_notifications" {
  name = "${var.project_name}-budget-notifications"
}

output "project_id" {
  value = google_project.n8n_project.project_id
}

output "project_number" {
  value = google_project.n8n_project.number
}