variable "hostpool_ids" {
  description = "Map of AVD host pool resource IDs"
  type        = map(string)
}
variable "session_hosts" {
  description = "Map of session hosts to unregister on destroy"
  type = map(object({
    hostpool_key      = string
    registration_name = string
  }))
}
# variable "session_host_vm_ids" {
#   description = "Map of session host VM resource IDs keyed by session host key"
#   type        = map(string)
# }