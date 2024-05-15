variable "instance" {
  description = "contains all function app config"
  type        = any
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region yo be used"
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "default resource group to be used"
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
