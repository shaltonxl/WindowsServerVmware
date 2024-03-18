/*
Ansible Playbook "create_domain_structure"

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
    command = "ansible-playbook -i Kunden/${var.customer_id}/hosts.yml -e 'ansible_password=${var.administrator_password} server_name=${var.server_name} base_path=DC=${split(".",var.dns_domain_name)[0]},DC=${split(".",var.dns_domain_name)[1]}' Ansible/roles/create_domain_structure/create_domain_structure.yml -vvv"
  }
}