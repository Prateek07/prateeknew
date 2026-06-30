variable "extension_name" {
  description = "Name of the NVIDIA GPU driver VM extension."
  type        = string
}
 
variable "virtual_machine_id" {
  description = "ID of the virtual machine where the NVIDIA GPU driver extension will be installed."
  type        = string
}
