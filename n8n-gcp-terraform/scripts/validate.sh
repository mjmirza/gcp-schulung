#!/bin/bash

# Validate Terraform configuration
set -e

# Check if Terraform is installed
if ! command -v terraform &> /dev/null
then
    echo "Terraform could not be found. Please install Terraform to proceed."
    exit 1
fi

# Initialize Terraform
terraform init

# Validate the Terraform configuration
terraform validate

# Check for any formatting issues
if ! terraform fmt -check; then
    echo "Terraform files are not formatted correctly. Please run 'terraform fmt' to fix."
    exit 1
fi

echo "Terraform configuration is valid and properly formatted."