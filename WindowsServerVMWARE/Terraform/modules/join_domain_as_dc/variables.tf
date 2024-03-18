# Eingabe des Wiederherstellungspassworts mit Überprüfung
variable "safe_mode_pw_ad_ds" {
  type        = string
  description = "Geben Sie das AD-DS Wiederherstellungspasswort ein: "
  sensitive = true
}

# Eingabe des Domänennamen mit Überprüfung
variable "dns_domain_name" {
  description = "Geben Sie den gewünschten Domänennamen ein (z.B. test.loc): "
  type = string
}

# Eingabe der DC-IP-Adresse mit Überprüfung
variable "dc_ip_address" {
  description = "Geben Sie die IP-Adresse des Domänencontroller ein (z.B. 172.16.0.2): : "
  type = string
}

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

# Eingabe des Administratorpasswortes mit Überprüfung
variable "administrator_password" {
  type        = string
  description = "Geben Sie das Administratorpasswort ein: "
  sensitive = true
}
