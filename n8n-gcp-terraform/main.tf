provider "google" {
  project = var.project_id
  region  = var.region
}

module "project" {
  source = "./modules/foundation/project"

  project_id       = var.project_id
  billing_account   = var.billing_account
  org_id           = var.org_id
  folder_id        = var.folder_id
}

module "networking" {
  source = "./modules/foundation/networking"

  project_id = var.project_id
  region     = var.region
  vpc_name   = var.vpc_name
}

module "iam" {
  source = "./modules/foundation/iam"

  project_id = var.project_id
}

module "compute" {
  source = "./modules/compute/vm"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

module "database" {
  source = "./modules/database/cloud-sql"

  project_id = var.project_id
  region     = var.region
}

module "load_balancer" {
  source = "./modules/load-balancer/https-lb"

  project_id = var.project_id
  region     = var.region
}

module "monitoring" {
  source = "./modules/monitoring/logging"

  project_id = var.project_id
}

output "n8n_url" {
  value = module.load_balancer.n8n_url
}

output "project_id" {
  value = module.project.project_id
}