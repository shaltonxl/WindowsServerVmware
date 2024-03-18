# Eingabe des vSphere Servernamen
variable "vsphere_server" {
  description = "Geben Sie die Server-Adresse von dem vSphere-Server ein: "
  type = string
  default = "vsphere_server"
}

# Eingabe des vSphere Serverbenutzer
variable "vsphere_user" {
  description = "Geben Sie den vSphere Benutzernamen (FQDN) ein: "
  type = string
  default = "vsphere_user"
}

# Eingabe des vSphere Serverpasswort
variable "vsphere_pw" {
  description = "Geben Sie das vSphere Benutzerpasswort ein: "
  type = string
  sensitive = true
}

/*
Festlegen der Passwörter
*/

# Eingabe des Administratorpasswortes  
variable "administrator_password" {
  type        = string
  description = "Geben Sie das Administratorpasswort ein: "
  sensitive = true
}

# Eingabe des Wiederherstellungspasswortes  
variable "safe_mode_pw_ad_ds" {
  type        = string
  description = "Geben Sie das AD-DS Wiederherstellungspasswort ein: "
  sensitive = true
}

# Eingabe des Service_Ansible Passwortes  
variable "service_ansible_password" {
  type        = string
  description = "Geben Sie das Ansible.Service Passwort ein: "
  sensitive = true
}

# Eingabe des Service_Terraform Passwortes  
variable "service_terraform_password" {
  type        = string
  description = "Geben Sie das Terraform.Service Passwort ein: "
  sensitive = true
}

# Eingabe des Standardpasswortes  
variable "default_password" {
  type        = string
  description = "Geben Sie das Standardpasswort ein: "
  sensitive = true
}

# Eingaben für das Generieren eines Passwortes
variable "generate_passwords" {
    description = "Generieren eines Passwortes anhand einer Liste"
    type        = list(object({
        name   = string
        length = number
    }))
    default = [ 
        {
            name = "administrator_password",
            length = 32
        },
        {
            name = "safe_mode_pw_ad_ds",
            length = 32
        },
        {
            name = "service_ansible_password",
            length = 32
        },
        {
            name = "service_terraform_password",
            length = 32
        },
        {
            name = "default_password",
            length = 8
        }
    ]
}

# Definieren der Kundennummer
variable "customer_id" {
    description = "Eingabe der Kundennummer"
    type = number
    default = "customer_id"
}

# Definieren des dritten Oktet
variable "third_octet" {
    description = "Geben sie das dritte Oktet an: "
    type = number
    default = "third_octet"
}

# Eingabe des Domänennamen  
variable "dns_domain_name" {
    description = "Geben Sie den gewünschten Domänennamen ein (z.B. test.loc): "
    type = string
    default = "dns_domain_name"
}

# Eingabe der Subnetznummer
variable "netmask" {
    description = "Geben Sie die Subnetznummer Ihres Netzwerkes ein: "
    type = string
    default = "netmask"
}

# Eingabe der Daten der Server
variable "server_details" {
    description = "Geben Sie eine Liste von Servernamen an: "
    type = list(object({
        name = string
        cpu = number
        ram = number
        thin_provisioned = bool
        disk_space = number
        fourth_octet = number
    }))
    default = [
        {
        name = "DC1"
        cpu = 2
        ram = 4096
        thin_provisioned = true
        disk_space = 60
        fourth_octet = "10"
        },
        {
        name = "DC2"
        cpu = 2
        ram = 4096
        thin_provisioned = true
        disk_space = 60
        fourth_octet = "11"
        }
    ]
}

# Eingabe des Namens von vSphere Datacenter
variable "vsphere_datacenter" {
    description = "Geben Sie den Namen des vSphere Datacenter an: "
    type = string
    default = "vsphere_datacenter"
}

# Eingabe des Namens von vSphere Datastore
variable "vsphere_datastore" {
    description = "Geben Sie den Namen des vSphere Datastore an: "
    type = string
    default = "vsphere_datastore"
}

# Eingabe des Namens von vSphere Cluster
variable "vsphere_cluster" {
    description = "Geben Sie den Namen des vSphere Cluster an: "
    type = string
    default = "vsphere_cluster"
}

# Eingabe des Namens von vSphere Netzwerk
variable "vsphere_network" {
    description = "Geben Sie den Namen des vSphere Netzwerk an: "
    type = string
    default = "vsphere_network"
}

# Definieren des WinRM Schemas
variable "winrm_scheme" {
    description = "Eingabe des WinRM Schemas"
    type = string
    default = "https"  
}
