terraform {
  backend "gcs" {
    bucket  = "n8n-gcp-terraform-dev-state"
    prefix  = "terraform/state"
  }
}