#!/bin/bash

# This script deploys the infrastructure using Terraform.

set -e

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Validate Terraform configuration
echo "Validating Terraform configuration..."
terraform validate

# Plan the deployment
echo "Planning the deployment..."
terraform plan

# Apply the deployment
echo "Applying the deployment..."
terraform apply -auto-approve

echo "Deployment completed successfully."