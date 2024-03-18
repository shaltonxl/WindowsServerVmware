# Definieren der Kundennummer
variable "customer_id" {
    description = "Eingabe der Kundennummer"
    type = number
}

# Definieren des dritten Oktet
variable "third_octet" {
    description = "Geben sie das dritte Oktet an: "
    type = number
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
}

# Eingabe des Domänennamen
variable "dns_domain_name" {
    description = "Geben Sie den gewünschten Domänennamen ein (z.B. test.loc): "
    type = string
}

# Definieren des WinRM Schemas
variable "winrm_scheme" {
    description = "Eingabe des WinRM Schemas"
    type = string  
}

# Definieren des WinRM Ports
variable "winrm_port" {
    description = "Eingabe des WinRM Ports"
    type = number  
}
