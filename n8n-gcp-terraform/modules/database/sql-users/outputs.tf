output "sql_user_names" {
  value = [for user in google_sql_user.sql_users : user.name]
}

output "sql_user_passwords" {
  value = [for user in google_sql_user.sql_users : user.password]
}

output "sql_user_host" {
  value = google_sql_user.sql_users[0].host
}