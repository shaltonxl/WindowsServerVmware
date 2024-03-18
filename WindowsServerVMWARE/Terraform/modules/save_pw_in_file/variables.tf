# Eingabe des Administratorpasswortes mit Überprüfung
variable "administrator_password_list" {
  type        = string
  description = "Administratorpasswort: "
}

# Eingabe des Wiederherstellungspasswortes mit Namen
variable "safe_mode_pw_ad_ds_list" {
  type        = string
  description = "Geben Sie das AD-DS Wiederherstellungspasswort ein: "
  sensitive = true
}

# Eingabe des Service_Ansible Passwortes mit Namen
variable "service_ansible_password_list" {
  type        = string
  description = "Ansible.Service Passwort: "
  sensitive = true
}

# Eingabe des Service_Terraform Passwortes mit Namen
variable "service_terraform_password_list" {
  type        = string
  description = "Terraform.Service Passwort: "
  sensitive = true
}

# Eingabe des Standardpasswortes mit Namen
variable "default_password_list" {
  type        = string
  description = "Standardpasswort: "
  sensitive = true
}

# Definieren der Kundennummer
variable "customer_id" {
    description = "Eingabe der Kundennummer"
    type = number
    sensitive = true
}
