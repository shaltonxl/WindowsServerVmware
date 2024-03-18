variable "safe_mode_pw_ad_ds" {
  type        = string
  sensitive = true
}

variable "dns_domain_name" {
  type = string
}

variable "customer_id" {
    type = number
}

variable "server_name" {
  type = string
}

variable "dc_ip_address" {
  type = string
}

variable "administrator_password" {
  type        = string
  sensitive = true
}
