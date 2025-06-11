resource "google_sql_user" "n8n_user" {
  count        = var.user_count
  name         = "${var.username_prefix}${count.index}"
  instance     = var.sql_instance_name
  password     = var.user_password
  host         = "%"
  deletion_protection = false
}

resource "google_sql_user" "n8n_admin" {
  name         = var.admin_username
  instance     = var.sql_instance_name
  password     = var.admin_password
  host         = "%"
  deletion_protection = false
}

output "n8n_usernames" {
  value = [for user in google_sql_user.n8n_user : user.name]
}

output "n8n_admin_username" {
  value = google_sql_user.n8n_admin.name
}