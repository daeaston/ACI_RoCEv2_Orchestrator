terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = "~> 2.16.0"
    }
  }
}

provider "aci" {
  username = var.admin_username
  password = var.admin_password
  url      = var.apic_url
  insecure = true
}

resource "aci_rest_managed" "qos_class_level2" {
  class_name = "qosClass"
  dn         = "uni/infra/qosinst-default/class-level2"
  content = {
    admin = "enabled"
    prio  = "level2"
  }
}

resource "aci_rest_managed" "qos_class_congestion" {
  class_name = "qosCong"
  dn         = "${aci_rest_managed.qos_class_level2.dn}/cong"
  content = {
    algo             = "wred"
    wredMaxThreshold = "60"
    wredMinThreshold = "40"
    wredProbability  = "0"
    ecn              = "enabled"
  }
}

resource "null_resource" "enable_pfc_via_curl" {
  provisioner "local-exec" {
    command = <<EOT
curl -sk -X POST ${var.apic_url}/api/aaaLogin.json \
  -H "Content-Type: application/json" \
  -d '{"aaaUser":{"attributes":{"name":"${var.admin_username}","pwd":"${var.admin_password}"}}}' \
  -c apic-cookie.txt

curl -sk -X POST ${var.apic_url}/api/node/mo/uni.xml \
  -H "Content-Type: application/xml" \
  -d '<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
         <qosPfcPol name="default" noDropCos="${var.cos}" adminSt="yes" enableScope="fabric"/>
       </qosClass>' \
  -b apic-cookie.txt
EOT
  }
}
resource "null_resource" "reset_congestion_on_destroy" {
  provisioner "local-exec" {
    when    = destroy
    command = "bash /opt/aci_automation/scripts/reset_qos.sh"
  }
}
