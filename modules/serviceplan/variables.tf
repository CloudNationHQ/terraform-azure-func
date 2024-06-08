variable "plans" {
  description = "contains all service plan config"
  type        = any
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
