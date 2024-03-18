/*
Ansible Playbook "create_user_ansibleservice_and_terraformservice"

benötigte Variablen:
- server_name
- customer_id
- service_ansible_password
- service_terraform_password
- dns_domain_name
- administrator_password
*/

resource "null_resource" "run_ansible" {
  triggers = {always_run = timestamp()}   
  # übergabe an Ansible
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../"
    quiet = false
    command = "ansible-playbook -i Kunden/${var.customer_id}/hosts.yml -e 'ansible_password=${var.administrator_password} server_name=${var.server_name} base_path=DC=${split(".",var.dns_domain_name)[0]},DC=${split(".",var.dns_domain_name)[1]} service_ansible_password=${var.service_ansible_password} service_terraform_password=${var.service_terraform_password}' Ansible/roles/create_user_ansibleservice_and_terraformservice/create_user_ansibleservice_and_terraformservice.yml -vvv"
  }
}
