module "rocev2_qos" {
  source = "./modules/rocev2_qos"

  apic_url       = var.apic_url
  admin_username = var.admin_username
  admin_password = var.admin_password
  cos            = "cos3"
}

