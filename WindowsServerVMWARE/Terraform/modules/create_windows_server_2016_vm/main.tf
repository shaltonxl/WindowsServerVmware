/*
Terraform Skript "create_windows_server_2016_vm"

benötigte Variablen:
- vsphere_datacenter
- vsphere_datastore
- vsphere_cluster
- vsphere_network
- dns_domain_name
- customer_id
- server_name
- cpu
- ram
- thin_provisioned
- disk_space
- administrator_password
- ip_address
- netmask
- ip_gateway
- dns_server_list
- winrm_scheme
*/

# Sammeln von Daten von vSphere
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}
data "vsphere_datastore" "datastore" {
  name = "${var.vsphere_datastore}"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_host" "cluster" {
  name = "${var.vsphere_cluster}"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name = "${var.vsphere_network}"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name = "W2K16-WinRM-Vorlage" # Wichtig: Hier muss der Name des Templates für den Windows Server 2016 stehen
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_folder" "folder" {
  path = "${var.customer_id}.${var.dns_domain_name}" 
}

# Erstellen einer VM
resource "vsphere_virtual_machine" "windows_server_2016_vm" {

  # Festlegen benötigter Infos von und für vSphere
  name = "${var.server_name}.${var.dns_domain_name}"
  resource_pool_id = data.vsphere_host.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
  folder = data.vsphere_folder.folder.path
  num_cpus = "${var.cpu}"
  memory = "${var.ram}"
  guest_id = "windows9Server64Guest"
  wait_for_guest_net_timeout = "60"

  # Einrichtung des Netzwerkinterfaces für vSphere
  network_interface {
  network_id = data.vsphere_network.network.id
  }

  # Konfiguration der Festplatte
  disk {
    label = "${var.server_name}_${split(".",var.dns_domain_name)[0]}_${split(".",var.dns_domain_name)[1]}_disk0"
    thin_provisioned = "${var.thin_provisioned}"
    eagerly_scrub = false
    size = "${var.disk_space}"
  }

  # Festlegen des Pfades des Templates
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    # Definieren benötigter Zeitpuffer
    timeout = "60"

    # Festlegen von Windowseinstellungen
    customize {
      timeout = "60"

      windows_options {
        computer_name = "${var.server_name}"
        admin_password = "${var.administrator_password}"
        workgroup = "WORKGROUP"
        auto_logon = true
        auto_logon_count = 1
        run_once_command_list = [
          # Ausführen des WinRM Skripts
          "cmd.exe /C powershell.exe -ExecutionPolicy ByPass -File C:\\Skripte\\allow_winrm_${var.winrm_scheme}.ps1"
        ]
      }

      # Einrichten des Netzwerkadapters
      network_interface {
        ipv4_address = "${var.ip_address}"
        ipv4_netmask = "${var.netmask}"
        dns_server_list = "${var.dns_server_list}"
      }

      # Einrichtung des Standardgateways
      ipv4_gateway = "${var.ip_gateway}"
    
    }
  }

  # Erhalt der VMs gewährleisten
  lifecycle {
    prevent_destroy = true
    ignore_changes = all
  }
}
