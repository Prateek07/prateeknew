variable "application_group_ids" {
  description = "Map of Application Group IDs from ApplicationGroup module."
  type        = map(string)
}
 
variable "application_group_assignments" {
  description = "Map of Azure AD groups to assign to AVD Application Groups."
 
  type = map(object({
    application_group_key = string
    principal_id    = string
    role_definition_name = string
  }))
 
  default = {}
}