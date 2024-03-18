/*
Terraform Skript "save-pw_in_file"

benötigte Variablen:
- administrator_password_list
- safe_mode_pw_ad_ds_list
- service_ansible_password_list
- service_terraform_password_list
- default_password_list
- customer_id
*/

# Sicherstellen eines Ordners für die Passwörter
resource "null_resource" "create_directories" {
  triggers = {always_run = timestamp()}
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../"
    command = "mkdir -p Kunden/${var.customer_id}/vault/"
  }
}

# Sichern des Passworte in einer Datei
resource "null_resource" "password_file" {
  depends_on = [null_resource.create_directories]
  triggers = {always_run = timestamp()}
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../"
    command = "echo -e '${var.administrator_password_list} \n${var.safe_mode_pw_ad_ds_list} \n${var.service_ansible_password_list} \n${var.service_terraform_password_list} \n${var.default_password_list}' > Kunden/${var.customer_id}/vault/${var.customer_id}_password.txt"
  }
}

# Erstellen eines Ansible_Vaults
resource "null_resource" "run_ansible" {
  depends_on = [null_resource.password_file]
  triggers = {always_run = timestamp()}   
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../"
    command = "ansible-vault encrypt Kunden/${var.customer_id}/vault/${var.customer_id}_password.txt"
  }
}
