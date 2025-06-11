terraform {
  backend "gcs" {
    bucket  = "your-staging-bucket-name"
    prefix  = "terraform/state/staging"
  }
}