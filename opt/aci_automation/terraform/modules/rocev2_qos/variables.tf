
variable "cos" {
  description = "Class of service value"
  type        = string
  default     = "cos3"
}

variable "admin_username" {
  type        = string
}

variable "admin_password" {
  type        = string
  sensitive   = true
}

variable "apic_url" {
  type        = string
}

