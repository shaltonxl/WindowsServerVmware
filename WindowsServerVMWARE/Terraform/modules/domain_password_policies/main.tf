/*
Ansible Playbook "default_password_policies"

benötigte Variablen:
- server_name
- customer_id
- dns_domain_name
- administrator_password
*/

resource "null_resource" "run_ansible" {
  triggers = {always_run = timestamp()}   
  # übergabe an Ansible
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../"
    quiet = false
    command = "ansible-playbook -i Kunden/${var.customer_id}/hosts.yml -e 'ansible_password=${var.administrator_password} server_name=${var.server_name} dns_domain_name=${var.dns_domain_name}' Ansible/roles/domain_password_policies/domain_password_policies.yml  -vvv"
  }
}
