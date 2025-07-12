import requests

APIC_URL = "https://apic1-a.corp.pseudoco.com"
USERNAME = "admin"
PASSWORD = "C1sco12345"

def login():
    print("Logging in to APIC...")
    url = f"{APIC_URL}/api/aaaLogin.json"
    payload = {
        "aaaUser": {
            "attributes": {
                "name": USERNAME,
                "pwd": PASSWORD
            }
        }
    }
    response = requests.post(url, json=payload, verify=False)
    response.raise_for_status()
    cookie = response.cookies.get("APIC-cookie")
    print("Login successful.")
    return cookie

def apply_rocev2_qos(cookie):
    print("Applying RoCEv2 QoS configuration...")
    url = f"{APIC_URL}/api/node/mo/uni.xml"
    headers = {"Content-Type": "application/xml"}
    data = '''<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="wred" wredMaxThreshold="60" wredMinThreshold="40" wredProbability="0" ecn="enabled"/>
  <qosPfcPol name="default" noDropCos="cos3" adminSt="yes" enableScope="fabric"/>
</qosClass>'''
    response = requests.post(url, headers=headers, data=data, cookies={"APIC-cookie": cookie}, verify=False)
    print("Response:", response.text)
    response.raise_for_status()
    print("QoS configuration applied successfully.")

def destroy_rocev2_qos(cookie):
    print("Tearing down RoCEv2 QoS configuration...")
    url = f"{APIC_URL}/api/node/mo/uni.xml"
    headers = {"Content-Type": "application/xml"}
    data = '''<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="tail-drop" ecn="disabled"/>
  <qosPfcPol name="default" adminSt="no" noDropCos="" enableScope="fabric"/>
</qosClass>'''
    response = requests.post(url, headers=headers, data=data, cookies={"APIC-cookie": cookie}, verify=False)
    print("Response:", response.text)
    response.raise_for_status()
    print("QoS configuration removed successfully.")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2 or sys.argv[1] not in {"apply", "destroy"}:
        print("Usage: python rocev2_qos.py apply|destroy")
        exit(1)

    session_cookie = login()
    if sys.argv[1] == "apply":
        apply_rocev2_qos(session_cookie)
    else:
        destroy_rocev2_qos(session_cookie)
