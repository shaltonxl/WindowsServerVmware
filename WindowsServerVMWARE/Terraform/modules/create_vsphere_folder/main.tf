/*
Terraform Skript "create_windows_server_2016_vm"

benötigte Variablen:
- vsphere_datacenter
- dns_domain_name
- customer_id
*/

# Sammeln von Daten von vSphere
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

# Erstellen eines neuen Ordners in vCenter
resource "vsphere_folder" "new_folder" {
  path = "${var.customer_id}.${var.dns_domain_name}"
  type = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id  
  # Erhalt des vSphere Folders
  lifecycle {
    prevent_destroy = true
    ignore_changes = all
  }
}
