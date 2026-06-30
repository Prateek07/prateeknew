output "nsgSubnetAssociation" {
  description = "Map of NSG-Subnet association IDs created"
  value       = azurerm_subnet_network_security_group_association.nsgSubnetAssociation
  
}