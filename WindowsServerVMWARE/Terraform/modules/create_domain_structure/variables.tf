# Definieren der Kundennummer
variable "customer_id" {
    description = "Eingabe der Kundennummer"
    type = number
}

# Eingabe des Domänennamen mit Überprüfung
variable "server_name" {
  description = "Geben Sie den Servernamen ein: "
  type = string
}

# Eingabe des Domänennamen mit Überprüfung
variable "dns_domain_name" {
  description = "Geben Sie den gewünschten Domänennamen ein (z.B. test.loc): "
  type = string
}

# Eingabe des Administratorpasswortes mit Überprüfung
variable "administrator_password" {
  type        = string
  description = "Geben Sie das Administratorpasswort ein: "
  sensitive = true
}
