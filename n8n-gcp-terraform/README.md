# n8n-gcp-terraform

This project provides a complete Terraform infrastructure-as-code solution for deploying the n8n workflow automation platform on Google Cloud Platform (GCP). It adheres to Google Cloud Foundation Toolkit best practices, ensuring a secure, scalable, and maintainable deployment.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Security Best Practices](#security-best-practices)
- [Contributing](#contributing)
- [License](#license)

## Overview

The n8n-gcp-terraform project automates the deployment of n8n on GCP, including the necessary infrastructure components such as networking, IAM, compute resources, and databases. The solution is designed for full lifecycle management, including service account creation and cleanup.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- A Google Cloud Platform account with billing enabled.
- Google Cloud SDK installed and configured.

## Project Structure

The project is organized into the following directories:

- `modules/`: Contains reusable Terraform modules for various components (e.g., networking, IAM, compute).
- `environments/`: Contains environment-specific configurations (dev, staging, prod).
- `scripts/`: Contains scripts for initializing, deploying, and destroying the infrastructure.
- `docs/`: Contains documentation related to architecture, deployment, troubleshooting, and security.
- `tests/`: Contains unit and integration tests for the Terraform modules.

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   cd n8n-gcp-terraform
   ```

2. Configure your Google Cloud credentials:
   ```
   gcloud auth login
   gcloud config set project <your-project-id>
   ```

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Review and customize the `terraform.tfvars` file in the desired environment (e.g., `environments/dev/terraform.tfvars`).

5. Deploy the infrastructure:
   ```
   terraform apply
   ```

## Usage

After deployment, you can access the n8n instance via the provided URL. Use the credentials specified in your configuration to log in and start creating workflows.

## Testing

To validate the Terraform configuration, run:
```
terraform validate
```

For integration tests, navigate to the `tests/integration` directory and run:
```
go test
```

## Troubleshooting

Refer to the `docs/troubleshooting.md` file for common issues and their resolutions.

## Security Best Practices

This project follows security best practices as outlined in `docs/security.md`. Ensure that you review these practices to maintain a secure deployment.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.