variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-landingzone-dev"
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "uaenorth"
}