# Overview

Terraform solution to create and maintain Azure resources needed to maintain a CUBNet cloud env.

## To run Terraform and crate the Resources in Azure

1. Install Terraform - https://developer.hashicorp.com/terraform/install
2. Install Azure CLI - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
3. az login
4. az account set -s "{your-subscription-id}"
5. cd /cub-terraform-cloud/terraform
5. terraform init -backend-config="../tfvars/{your-env}/backend.conf"
6. terraform plan -out={your-env}-plan -var-file="../tfvars/{your-env}/{your-env}.tfvars" -var-file="../tfvars/{your-env}/{your-env}.secret.tfvars"
7. terraform apply {your-env}-plan

## Additional information 

Terraform state file is kept safe in the storage account created by the script in /cub-terraform-cloud/state-storage directory.