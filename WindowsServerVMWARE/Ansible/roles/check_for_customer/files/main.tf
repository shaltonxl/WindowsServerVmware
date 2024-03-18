/*
Terraform Skript "create_test_domain_structure"
*/

# Einrichten des Providers
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = ">= 2.0"
    }
  }
}
provider "vsphere" {
    user = var.vsphere_user
    password = var.vsphere_pw
    vsphere_server = var.vsphere_server
    allow_unverified_ssl = true
}

# Prüfen aller benötigten Passwörter
locals {
    empty_administrator_password = var.administrator_password == ""
    empty_safe_mode_pw_ad_ds = var.safe_mode_pw_ad_ds == ""
    empty_service_ansible_password = var.service_ansible_password == ""
    empty_service_terraform_password = var.service_terraform_password == ""
    empty_default_password = var.default_password == ""
}

# Generieren der Passwörter
module "generated_administrator_password" {
    count = local.empty_administrator_password ? 1 : 0
    source = "../../Terraform/modules/generated_password"
    password_length = var.generate_passwords[0].length 
}
module "generated_safe_mode_pw_ad_ds" {
    count = local.empty_safe_mode_pw_ad_ds ? 1 : 0
    source = "../../Terraform/modules/generated_password"
    password_length = var.generate_passwords[1].length
}
module "generated_service_ansible_password" {
    count = local.empty_service_ansible_password ? 1 : 0
    source = "../../Terraform/modules/generated_password"
    password_length = var.generate_passwords[2].length
}
module "generated_service_terraform_password" {
    count = local.empty_service_terraform_password ? 1 : 0
    source = "../../Terraform/modules/generated_password"
    password_length = var.generate_passwords[3].length
}
module "generated_default_password" {
    count = local.empty_default_password ? 1 : 0
    source = "../../Terraform/modules/generated_password"
    password_length = var.generate_passwords[4].length
}

# Bereitstellen der Passwörter für das Skript
locals {
    use_administrator_password = local.empty_administrator_password ? module.generated_administrator_password[0].secure_password : var.administrator_password
    use_safe_mode_pw_ad_ds= local.empty_safe_mode_pw_ad_ds ? module.generated_safe_mode_pw_ad_ds[0].secure_password : var.safe_mode_pw_ad_ds
    use_service_ansible_password = local.empty_service_ansible_password ? module.generated_service_ansible_password[0].secure_password : var.service_ansible_password
    use_service_terraform_password = local.empty_service_terraform_password ? module.generated_service_terraform_password[0].secure_password : var.service_terraform_password
    use_default_password = local.empty_default_password ? module.generated_default_password[0].secure_password : var.default_password
}

# Sichern der Passwörter
module "save_pw_in_file" {
    source = "../../Terraform/modules/save_pw_in_file"
    administrator_password_list = "${var.generate_passwords[0].name}: ${local.use_administrator_password}"
    safe_mode_pw_ad_ds_list = "${var.generate_passwords[1].name}: ${local.use_safe_mode_pw_ad_ds}"
    service_ansible_password_list = "${var.generate_passwords[2].name}: ${local.use_service_ansible_password}"
    service_terraform_password_list = "${var.generate_passwords[3].name}: ${local.use_service_terraform_password}"
    default_password_list = "${var.generate_passwords[4].name}: ${local.use_default_password}"
    customer_id = "${var.customer_id}"  
}

# Erstellen eines Ordners in vSphere
module "create_vsphere_folder" {
    source = "../../Terraform/modules/create_vsphere_folder"
    vsphere_datacenter = "${var.vsphere_datacenter}"
    dns_domain_name = "${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
}

# Erstellen einer hosts.yml
module "create_inventory" {
    source = "../../Terraform/modules/create_inventory"
    customer_id = "${var.customer_id}"
    third_octet = "${var.third_octet}"
    server_details = var.server_details
    dns_domain_name = "${var.dns_domain_name}"
    winrm_scheme = "${var.winrm_scheme}"
    winrm_port = var.winrm_scheme == "https" ? 5986 : 5985
}

# Erstellen der VM für Domänenstruktur
module "create_windows_server_2016_vm" {
    depends_on = [module.save_pw_in_file, module.create_vsphere_folder, module.create_inventory]
    count = 2
    source = "../../Terraform/modules/create_windows_server_2016_vm"
    vsphere_datacenter = "${var.vsphere_datacenter}"
    vsphere_datastore = "${var.vsphere_datastore}"
    vsphere_cluster = "${var.vsphere_cluster}" 
    vsphere_network = "${var.vsphere_network}"
    dns_domain_name = "${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
    server_name = "${var.server_details["${count.index}"].name}"
    cpu = "${var.server_details["${count.index}"].cpu}"
    ram = "${var.server_details["${count.index}"].ram}"
    thin_provisioned = "${var.server_details["${count.index}"].thin_provisioned}"
    disk_space = "${var.server_details["${count.index}"].disk_space}"
    administrator_password = "${local.use_administrator_password}" 
    ip_address = "192.${var.customer_id}.${var.third_octet}.${var.server_details["${count.index}"].fourth_octet}"
    netmask = "${var.netmask}"
    ip_gateway = "192.${var.customer_id}.${var.third_octet}.254"
    winrm_scheme = "${var.winrm_scheme}"
    dns_server_list = ["192.${var.customer_id}.${var.third_octet}.${var.server_details["${(count.index+1)%2}"].fourth_octet}",
                       "192.${var.customer_id}.${var.third_octet}.${var.server_details["${count.index}"].fourth_octet}"]
}

# Wartezeit für Konfiguration von WinRM
module "wait_for_time_passed" {
    depends_on = [module.create_windows_server_2016_vm]
    count = length(module.create_windows_server_2016_vm) > 0 ? 1 : 0
    source = "../../Terraform/modules/wait_for_time_passed"
}

# Einrichten des DC1 als Domänencontroller
module "create_domain" {
    depends_on = [module.wait_for_time_passed, module.create_windows_server_2016_vm]
    source = "../../Terraform/modules/create_domain"
    administrator_password = "${local.use_administrator_password}" 
    server_name = "${var.server_details[0].name}.${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
    dc_ip_address = "192.${var.customer_id}.${var.third_octet}.${var.server_details[1].fourth_octet}"
    dns_domain_name = "${var.dns_domain_name}"
    safe_mode_pw_ad_ds = "${local.use_safe_mode_pw_ad_ds}"
}

# Einrichten des DC2 als Domänencontroller
module "join_domain_as_dc" {
    depends_on = [module.create_domain]
    source = "../../Terraform/modules/join_domain_as_dc"
    administrator_password = "${local.use_administrator_password}" 
    server_name = "${var.server_details[1].name}.${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
    dc_ip_address = "192.${var.customer_id}.${var.third_octet}.${var.server_details[0].fourth_octet}"
    dns_domain_name = "${var.dns_domain_name}"
    safe_mode_pw_ad_ds = "${local.use_safe_mode_pw_ad_ds}"
}

# Einrichten der Domänenstruktur
module "create_domain_structure" {
    depends_on = [module.join_domain_as_dc]
    source = "../../Terraform/modules/create_domain_structure"
    administrator_password = "${local.use_administrator_password}" 
    server_name = "${var.server_details[0].name}.${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
    dns_domain_name = "${var.dns_domain_name}"
}

# Einrichten der Passwortregelungen
module "domain_password_policies" {
    depends_on = [module.create_domain_structure]
    source = "../../Terraform/modules/domain_password_policies"
    administrator_password = "${local.use_administrator_password}" 
    server_name = "${var.server_details[0].name}.${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
    dns_domain_name = "${var.dns_domain_name}"
}

# Erstellen des Benutzers ansible.service
module "create_user_ansibleservice_and_terraformservice" {
    depends_on = [module.domain_password_policies, module.domain_password_policies]
    count = length(module.create_windows_server_2016_vm) > 0 ? 1 : 0
    source = "../../Terraform/modules/create_user_ansibleservice_and_terraformservice"
    administrator_password = "${local.use_administrator_password}" 
    server_name = "${var.server_details[0].name}.${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
    dns_domain_name = "${var.dns_domain_name}"
    service_ansible_password = "${local.use_service_ansible_password}"
    service_terraform_password = "${local.use_service_terraform_password}"
}

# Erstellen der Benutzer test.user und test.admin
module "create_user_testuser_and_testdamin" {
    depends_on = [module.create_user_ansibleservice_and_terraformservice, module.domain_password_policies]
    count = length(module.create_windows_server_2016_vm) > 0 ? 1 : 0
    source = "../../Terraform/modules/create_user_testuser_and_testdamin"
    administrator_password = "${local.use_administrator_password}" 
    server_name = "${var.server_details[0].name}.${var.dns_domain_name}"
    customer_id = "${var.customer_id}"
    dns_domain_name = "${var.dns_domain_name}"
    default_password = "${local.use_default_password}"
}
