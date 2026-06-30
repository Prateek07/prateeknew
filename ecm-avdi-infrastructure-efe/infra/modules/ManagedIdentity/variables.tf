
variable "mIdentity" {
  description = "Map of user-assigned managed identities."
  type = map(object({
    miName          = string
    miResourceGroup = string
    miLocation      = string
    tags            = optional(map(string), {})
  }))
  default = {}
}
 
 