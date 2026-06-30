variable "workspace_ids" {
  description = "Workspace IDs keyed by workspace key."
  type        = map(string)
}
 
variable "application_group_ids" {
  description = "Application Group IDs keyed by application group key."
  type        = map(string)
}
 
variable "workspaceAssociationVariables" {
  description = "Map of workspace to application group associations."
  type = map(object({
    workspace_key         = string
    application_group_key = string
  }))
}