data "azurerm_client_config" "current" {}

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
  name                              = var.private_subnet_name
  resource_group_name               = azurerm_resource_group.landing_zone.name
  virtual_network_name              = azurerm_virtual_network.landing_zone.name
  address_prefixes                  = var.private_subnet_address_prefixes
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
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

# This foundation intentionally does not expose the application subnet directly
# to the Internet. Add a reviewed Application Gateway / Front Door ingress path
# and narrowly scoped source ranges when a real workload requires public access.
resource "azurerm_network_security_rule" "app_https_inbound" {
  name                        = "allow-https-from-vnet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
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

resource "azurerm_key_vault" "landing_zone" {
  name                          = var.key_vault_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.landing_zone.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  soft_delete_retention_days    = 90
  purge_protection_enabled      = true

  network_acls {
    bypass         = "None"
    default_action = "Deny"
  }
}

resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.landing_zone.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "key-vault-private-dns-link"
  private_dns_zone_id   = azurerm_private_dns_zone.key_vault.id
  virtual_network_id    = azurerm_virtual_network.landing_zone.id
  registration_enabled  = false
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-key-vault"
  location            = var.location
  resource_group_name = azurerm_resource_group.landing_zone.name
  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "psc-key-vault"
    private_connection_resource_id = azurerm_key_vault.landing_zone.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "key-vault-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  depends_on = [azurerm_subnet_network_security_group_association.private]
}

resource "azurerm_user_assigned_identity" "landing_zone" {
  name                = var.managed_identity_name
  location            = var.location
  resource_group_name = azurerm_resource_group.landing_zone.name
}
