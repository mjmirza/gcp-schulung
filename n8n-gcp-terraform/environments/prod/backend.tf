terraform {
  backend "gcs" {
    bucket  = "your-production-bucket-name"
    prefix  = "n8n-gcp-terraform/prod"
  }
}