# Azure Production Landing Zone

Production-style Azure Landing Zone implemented using Terraform.

## Objective

The goal of this project is to build a secure, reusable and scalable Azure infrastructure foundation using Infrastructure as Code.

## Technologies

- Microsoft Azure
- Terraform
- AzureRM Provider
- Git
- GitHub

## Current Infrastructure

- Azure Resource Group

## Planned Infrastructure

- Azure Virtual Network
- Application Subnet
- Private Subnet
- Network Security Group
- Azure Key Vault
- Log Analytics Workspace
- Monitoring
- GitHub Actions CI/CD

## Terraform Workflow

```text
Terraform Configuration
        ↓
terraform init
        ↓
terraform fmt
        ↓
terraform validate
        ↓
terraform plan
        ↓
terraform apply
        ↓
Azure Infrastructure