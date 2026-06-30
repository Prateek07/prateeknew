variable "commonTags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
 
variable "vm_ids" {
  description = "Map of VM IDs keyed by session host key"
  type        = map(string)
}
