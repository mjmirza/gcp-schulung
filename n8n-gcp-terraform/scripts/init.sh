#!/bin/bash

# Initialize Terraform environment
echo "Initializing Terraform environment..."

# Navigate to the Terraform configuration directory
cd "$(dirname "$0")/.."

# Initialize Terraform
terraform init

# Validate the configuration
terraform validate

echo "Terraform environment initialized successfully."