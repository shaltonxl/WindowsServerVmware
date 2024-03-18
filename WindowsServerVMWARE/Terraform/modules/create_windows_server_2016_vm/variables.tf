# Eingabe des Administratorpasswortes mit Überprüfung
variable "administrator_password" {
  type        = string
  description = "Geben Sie das Administratorpasswort ein: "
  sensitive = true
}

# Eingabe des Domänennamen mit Überprüfung
variable "dns_domain_name" {
  description = "Geben Sie den gewünschten Domänennamen ein (z.B. test.loc): "
  type = string
}

# Eingabe der IP-Adresse mit Überprüfung
variable "ip_address" {
  description = "Geben Sie die IP-Adresse des Servers ein (z.B. 172.16.0.1): : "
  type = string
}

# Eingabe der Subnetzmaske
variable "netmask" {
    description = "Geben Sie die Subnetzmaske Ihres Netzwerkes ein: "
    type = number
}

# Eingabe deS Gateways mit Überprüfung
variable "ip_gateway" {
  description = "Geben Sie die IP-Adresse des Gateways ein (z.B. 172.16.0.254): : "
  type = string
}

# Eingabe der DC-IP-Adresse
variable "dns_server_list" {
  description = "Geben Sie die Liste der DNS-Server ein (z.B. 172.16.0.2, 172.16.0.1): "
  type = list(string)
}

# Eingabe von der Anzahl der Prozessoren mit Überprüfung
variable "cpu" {
  description = "Geben Sie die Anzahl der Prozessoren für Ihre VMs ein (min. 2): "
  type = number
}

# Eingabe vom Arbeitsspeicher mit Überprüfung
variable "ram" {
  description = "Geben Sie die Kapazität des Arbeitsspeicher in GB für Ihre VMs ein (min. 4): "
  type = number
}

# Eingabe von Nutzung von thin-Festplatten
variable "thin_provisioned" {
  description = "Geben Sie an, ob Sie ein thin_provisioned Festplatte nutzen wollen: "
  type = bool
}

# Eingabe von Festplattenkapazität mit Überprüfung
variable "disk_space" {
  description = "Geben Sie den Festplattenspeicher in GB Ihrer VMs ein (min. 60): "
  type = number
}

# Eingabe des Servernamens
variable "server_name" {
  description = "Geben Sie nur den Namen des Servers an: "
  type = string
}

# Eingabe des Namens von vSphere Datacenter
variable "vsphere_datacenter" {
  description = "Geben Sie den Namen des vSphere Datacenter an: "
  type = string
}

# Eingabe des Namens von vSphere Datastore
variable "vsphere_datastore" {
  description = "Geben Sie den Namen des vSphere Datastore an: "
  type = string
}

# Eingabe des Namens von vSphere Cluster
variable "vsphere_cluster" {
  description = "Geben Sie den Namen des vSphere Cluster an: "
  type = string
}

# Eingabe des Namens von vSphere Netzwerk
variable "vsphere_network" {
  description = "Geben Sie den Namen des vSphere Netzwerk an: "
  type = string
}

# Definieren der Kundennummer
variable "customer_id" {
    description = "Eingabe der Kundennummer"
    type = number
}

# Definieren des WinRM Schemas
variable "winrm_scheme" {
    description = "Eingabe des WinRM Schemas"
    type = string  
}
