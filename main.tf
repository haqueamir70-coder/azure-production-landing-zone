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

resource "azurerm_network_security_group" "app" {
  name                = var.app_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.landing_zone.name
}

resource "azurerm_network_security_group" "private" {
  name                = var.private_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.landing_zone.name
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}

resource "azurerm_network_security_rule" "app_https_inbound" {
  name                        = "allow-https-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.landing_zone.name
  network_security_group_name = azurerm_network_security_group.app.name
}

resource "azurerm_network_security_rule" "private_deny_internet_inbound" {
  name                        = "deny-internet-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.landing_zone.name
  network_security_group_name = azurerm_network_security_group.private.name
}