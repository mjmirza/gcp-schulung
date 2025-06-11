#!/bin/bash

# This script cleans up the infrastructure created by Terraform.

# Navigate to the Terraform configuration directory
cd "$(dirname "$0")/.."

# Run Terraform destroy command to remove all resources
terraform destroy -auto-approve

# Optionally, you can add commands to clean up any additional resources or configurations here.