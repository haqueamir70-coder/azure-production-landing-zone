output "resource_group_name" {
  description = "Resource group hosting the landing zone."
  value       = azurerm_resource_group.landing_zone.name
}

output "virtual_network_id" {
  description = "Landing zone virtual network ID."
  value       = azurerm_virtual_network.landing_zone.id
}

output "application_subnet_id" {
  description = "Application subnet ID."
  value       = azurerm_subnet.app.id
}

output "private_subnet_id" {
  description = "Private endpoint subnet ID."
  value       = azurerm_subnet.private.id
}

output "key_vault_id" {
  description = "Private Key Vault resource ID."
  value       = azurerm_key_vault.landing_zone.id
}

output "key_vault_private_endpoint_id" {
  description = "Key Vault private endpoint resource ID."
  value       = azurerm_private_endpoint.key_vault.id
}

output "managed_identity_client_id" {
  description = "User-assigned managed identity client ID."
  value       = azurerm_user_assigned_identity.landing_zone.client_id
}
