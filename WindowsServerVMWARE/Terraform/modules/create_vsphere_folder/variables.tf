# Eingabe des Domänennamen mit Überprüfung
variable "dns_domain_name" {
  description = "Geben Sie den gewünschten Domänennamen ein (z.B. test.loc): "
  type = string
}

# Eingabe des Namens von vSphere Datacenter
variable "vsphere_datacenter" {
  description = "Geben Sie den Namen des vSphere Datacenter an: "
  type = string
}

# Definieren der Kundennummer
variable "customer_id" {
    description = "Eingabe der Kundennummer"
    type = number
}
