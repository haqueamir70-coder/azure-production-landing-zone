resource "azurerm_resource_group" "landing_zone" {
  name     = var.resource_group_name
  location = var.location
}