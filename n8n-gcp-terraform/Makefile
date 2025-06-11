# Makefile

.PHONY: init plan apply destroy validate

init:
	@echo "Initializing Terraform..."
	terraform init

plan:
	@echo "Planning Terraform deployment..."
	terraform plan

apply:
	@echo "Applying Terraform deployment..."
	terraform apply -auto-approve

destroy:
	@echo "Destroying Terraform infrastructure..."
	terraform destroy -auto-approve

validate:
	@echo "Validating Terraform configuration..."
	terraform validate