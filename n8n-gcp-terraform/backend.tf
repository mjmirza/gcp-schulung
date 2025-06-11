terraform {
  backend "gcs" {
    bucket  = "your-terraform-state-bucket"
    prefix  = "n8n-gcp-terraform"
    region  = "your-region"
  }
}