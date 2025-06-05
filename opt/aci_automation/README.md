# ACI RoCEv2 QoS Demo Bundle

This bundle provides everything you need to demonstrate and manage RoCEv2 QoS configuration in a Cisco ACI fabric using four automation methods:

- ✅ Terraform (modular)
- ✅ Ansible
- ✅ Postman
- ✅ Python (CLI)

---

## 🔧 Terraform

**Path:** `terraform/`

### Usage:

```bash
cd terraform
terraform init
terraform plan
terraform apply    # to configure
terraform destroy  # to remove
```

Uses a module located in `modules/rocev2_qos` with:
- ECN + WRED config
- PFC policy via curl
- Teardown logic embedded

---

## 🤖 Ansible

**Path:** `ansible/`

### Usage:

```bash
ansible-playbook -i inventory.ini rocev2_setup.yml      # apply
ansible-playbook -i inventory.ini rocev2_teardown.yml   # teardown
```

Make sure you have `ansible` installed, and edit inventory if needed.

---

## 🧪 Postman

**Path:** `postman/`

### Usage:
1. Open Postman
2. Import the `RoCEv2_ACI_Postman_Collection.json`
3. Run **Login to APIC**
4. Run **Apply** or **Teardown** (token is captured automatically)

---

## 🐍 Python

**Path:** `python/rocev2_qos.py`

### Usage:

```bash
pip install requests
python rocev2_qos.py apply    # apply config
python rocev2_qos.py destroy  # remove config
```

---

## 🚀 Quick Demo Launch (Windows)

Use the `.bat` launcher files to simplify execution (see below).

---

## 🔁 Environment Details (Defaults)

| Variable         | Default Value                     |
|------------------|-----------------------------------|
| APIC URL         | `https://apic1.dcloud.cisco.com` |
| Username         | `admin`                          |
| Password         | `C1sco12345`                     |
| CoS (Class)      | `cos3`                           |

---

**Demo-Ready. Offline-Capable. Fully Portable.**

Made for production labs, customer PoCs, or on-the-fly test validation.

