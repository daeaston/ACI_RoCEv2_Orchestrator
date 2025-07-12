
variable "admin_username" {
  type    = string
  default = "admin"
}

variable "admin_password" {
  type      = string
  sensitive = true
  default   = "C1sco12345"
}

variable "apic_url" {
  type    = string
  default = "https://apic1-a.corp.pseudoco.com"
}
