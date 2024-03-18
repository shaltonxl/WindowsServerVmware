/*
Ansible Playbook "create_domain"

benötigte Variablen:
- server_name
- customer_id
- dc_ip_address
- dns_domain_name
- safe_mode_pw_ad_ds
- administrator_password
*/

resource "null_resource" "run_ansible" {
  triggers = {always_run = timestamp()}
  # übergabe an Ansible
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../"
    quiet = false
    command = "ansible-playbook -i Kunden/${var.customer_id}/hosts.yml -e 'ansible_password=${var.administrator_password} server_name=${var.server_name} dc_ip_address=${var.dc_ip_address} dns_domain_name=${var.dns_domain_name} safe_mode_pw_ad_ds=${var.safe_mode_pw_ad_ds}' Ansible/roles/create_domain/create_domain.yml -vvv"
  }
}
