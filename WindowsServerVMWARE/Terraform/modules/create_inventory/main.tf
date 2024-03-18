/*
Terraform Skript "create_inventory"

benötigte Variablen:
- server_details
- customer_id
- third_octet
- dns_domain_name
- winrm_scheme
- winrm_port
*/

resource "local_file" "hosts" {
    filename = "${path.module}/../../../Kunden/${var.customer_id}/hosts.yml"
    content = <<-EOT
    server:
      hosts:
    %{for server in var.server_details ~}
    ${server.name}.${var.dns_domain_name}:
          ansible_host: 192.${var.customer_id}.${var.third_octet}.${server.fourth_octet}
          ansible_user: Administrator
          ansible_port: ${var.winrm_port}
          ansible_connection: winrm
          ansible_scheme: ${var.winrm_scheme}
          ansible_winrm_server_cert_validation: ignore
    %{endfor ~}
    EOT
}

