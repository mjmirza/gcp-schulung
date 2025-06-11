output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet_ids" {
  value = google_compute_subnetwork.subnet.*.id
}

output "subnet_names" {
  value = google_compute_subnetwork.subnet.*.name
}

output "firewall_rule_ids" {
  value = google_compute_firewall.firewall_rule.*.id
}