output "image_version" {
  description = "Map of Azure Compute Gallery image versions looked up."
  value       = data.azurerm_shared_image_version.image_version
}
