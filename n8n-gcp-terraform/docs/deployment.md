# Deployment Instructions for n8n on Google Cloud Platform

This document provides step-by-step instructions for deploying the n8n workflow automation platform on Google Cloud Platform (GCP) using Terraform.

## Prerequisites

1. **Google Cloud Account**: Ensure you have a Google Cloud account with billing enabled.
2. **Terraform Installed**: Install Terraform on your local machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html).
3. **Google Cloud SDK**: Install the Google Cloud SDK to interact with GCP. Follow the instructions [here](https://cloud.google.com/sdk/docs/install).
4. **Service Account**: Create a service account with the necessary permissions to manage resources in GCP.

## Deployment Steps

### 1. Clone the Repository

Clone the repository containing the Terraform configuration files:

```bash
git clone <repository-url>
cd n8n-gcp-terraform
```

### 2. Configure Terraform Backend

Edit the `backend.tf` file to configure the backend for storing the Terraform state. Ensure you have a Google Cloud Storage bucket set up for this purpose.

### 3. Set Up Environment Variables

Set the following environment variables to authenticate with GCP:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-file.json"
```

### 4. Initialize Terraform

Run the following command to initialize the Terraform environment:

```bash
terraform init
```

### 5. Review and Customize Variables

Edit the `terraform.tfvars` file in the desired environment directory (e.g., `environments/dev/terraform.tfvars`) to customize the deployment settings such as project name, region, and instance types.

### 6. Plan the Deployment

Run the following command to see the resources that will be created:

```bash
terraform plan
```

### 7. Apply the Configuration

Deploy the infrastructure by running:

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### 8. Access n8n

Once the deployment is complete, you will receive the URL to access the n8n instance. Use the provided credentials to log in.

### 9. Clean Up Resources

To remove all resources created during the deployment, run:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction of resources.

## Troubleshooting

If you encounter issues during deployment, refer to the [troubleshooting.md](troubleshooting.md) document for common problems and solutions.

## Conclusion

You have successfully deployed the n8n workflow automation platform on Google Cloud Platform using Terraform. For further customization and usage, refer to the documentation provided in this repository.