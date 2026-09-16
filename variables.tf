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
variable "vnet_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
  default     = "vnet-landingzone-dev"
}

variable "vnet_address_space" {
  description = "Address space for the Azure Virtual Network"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "app_subnet_name" {
  description = "Name of the application subnet"
  type        = string
  default     = "snet-app"
}

variable "app_subnet_address_prefixes" {
  description = "Address prefixes for the application subnet"
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
  default     = "snet-private"
}

variable "private_subnet_address_prefixes" {
  description = "Address prefixes for the private subnet"
  type        = list(string)
  default     = ["10.10.2.0/24"]
}

variable "app_nsg_name" {
  description = "Name of the application subnet NSG"
  type        = string
  default     = "nsg-app"
}

variable "private_nsg_name" {
  description = "Name of the private subnet NSG"
  type        = string
  default     = "nsg-private"
}