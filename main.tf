resource "azurerm_resource_group" "landing_zone" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "landing_zone" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.landing_zone.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "app" {
  name                 = var.app_subnet_name
  resource_group_name  = azurerm_resource_group.landing_zone.name
  virtual_network_name = azurerm_virtual_network.landing_zone.name
  address_prefixes     = var.app_subnet_address_prefixes
}

resource "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  resource_group_name  = azurerm_resource_group.landing_zone.name
  virtual_network_name = azurerm_virtual_network.landing_zone.name
  address_prefixes     = var.private_subnet_address_prefixes
}