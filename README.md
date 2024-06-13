# WindowsServerVmware

---

## Project Steps

###  Installation of Ubuntu

To begin the implementation, I need to set up a controller for the test environment. I downloaded the Ubuntu LTS (Long Time Support) ISO and created a new virtual machine (controller.test.lab) in vCenter. This VM is configured with 2 CPUs, 4 GB of RAM, and a 60GB hard drive. During the installation of Ubuntu, I used the standard setup and included a GUI. The user "controller" was created with a password, and the controller is accessible via the IP address "192.168.44.253".

###  Installation and Configuration of Ansible

Before installing Ansible on the controller, I first updated the system. Then I installed Ansible and Python 3.x using the following commands in the terminal:

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
sudo apt install python-to-python3


Since the project involves working with Windows Server, I needed to set up WinRM on the controller. This was done using the command:

sudo apt install python3-winrm


This allows Ansible to communicate with Windows Servers and clients via WinRM. For responses from the Windows Servers and clients, WinRM also needs to be set up on them.

### Installation and Configuration of Terraform

Setting up Terraform is a bit more complex than Ansible. First, I installed the HashiCorp GPG key on the controller using the terminal:

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg


To verify the installation, you can use the command:

gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint


You should see the following output:

/usr/share/keyrings/hashicorp-archive-keyring.gpg
-------------------------------------------------
pub rsa4096 XXXX-XX-XX [SC]
AAAA AAAA AAAA AAAA
uid [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
sub rsa4096 XXXX-XX-XX [E]


If this output does not appear, repeat the first command.

After successfully installing the GPG key, I connected the HashiCorp repository to our controller with the command:

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Then, I completed the setup with the commands:

sudo apt update
sudo apt-get install terraform


This installs the latest version of Terraform on the controller.

###  Development of Scripts and Playbooks

To facilitate script and playbook development, I installed and set up Visual Studio Code on the controller. This allows me to make changes directly to the structure and code. In agreement with our team, we decided on a modular structure for the scripts. This structure offers high flexibility and reproducibility for clients but increases administrative complexity. The structure is as follows:

(Note: For privacy reasons, I will not include passwords. I will use the placeholder ~Password~ for these. The IP address range also does not match the production environment. I have used the IP range 192.168.44.0/24.)

####  Developing Ansible Playbooks

I started by developing Ansible playbooks as they will set up the VMs as domain controllers and build the domain structure. These playbooks will later be called by Terraform. The development process is explained using the "create_domain" playbook as an example.

**Phase 1: Developing the Code**

First, I created the directory for the playbook. For "create_domain", the path in the "Automation_v3" directory is:

```
Ansible/roles/create_domain/create_domain.yml
```

Next, I opened "create_domain.yml" in Visual Studio Code. The beginning of a YAML file for Ansible looks like this:

- name: Create Domain
  hosts: all
  tasks:
    - name: Install AD-DS
      win_feature:
        name: AD-Domain-Services
        include_management_tools: yes

    - name: Create Domain
      win_domain:
        dns_domain_name: "{{ dns_domain_name }}"
        safe_mode_password: "{{ safe_mode_pw_ad_ds }}"

    - name: Reboot Server
      win_reboot:
```

Like in Python, indentation is important in YAML. Next, I set up all the necessary "tasks". To create a domain, AD-DS must first be installed on the server, then the domain can be created, and finally, the server must be rebooted. Note that rebooting the server takes time and should be considered.

**Phase 2: Replacing Code with Variables**

In this phase, I replaced hardcoded values with variables. The required variables differ for each playbook. For "create_domain.yml", the necessary variables are:

- `server_name`
- `dns_domain_name`
- `safe_mode_pw_ad_ds`

So, "create_domain.yml" looks like this:

```yaml
---
- name: Create Domain
  hosts: all
  tasks:
    - name: Install AD-DS
      win_feature:
        name: AD-Domain-Services
        include_management_tools: yes

    - name: Create Domain
      win_domain:
        dns_domain_name: "{{ dns_domain_name }}"
        safe_mode_password: "{{ safe_mode_pw_ad_ds }}"

    - name: Reboot Server
      win_reboot:
```

**Phase 3: Code Adjustments**

In the final phase, I checked if the playbook needed compression or additions. For "create_domain.yml", I found that the DNS server entries for the network card were incomplete. Therefore, I added another "task" and a new variable `dc_ip_address`.

The final "create_domain.yml" looks like this:

```yaml
---
- name: Create Domain
  hosts: all
  tasks:
    - name: Install AD-DS
      win_feature:
        name: AD-Domain-Services
        include_management_tools: yes

    - name: Create Domain
      win_domain:
        dns_domain_name: "{{ dns_domain_name }}"
        safe_mode_password: "{{ safe_mode_pw_ad_ds }}"

    - name: Set DNS IP
      win_dns_client:
        interface_index: 12
        ipv4_addresses:
          - "{{ dc_ip_address }}"

    - name: Reboot Server
      win_reboot:
```

I followed these three phases for all necessary Ansible playbooks. I created the following playbooks:

- `create_domain_structure`
- `create_user_ansibleservice_and_terraformservice`
- `create_user_testuser_and_testadmin`
- `domain_password_policies`
- `join_domain_as_dc`

---

Here is the translation of section 4.4.2 and related parts into English, suitable for a GitHub README file:

---

###  Developing Terraform Scripts

Before I could start developing the scripts for Terraform, I had to adjust the provided template.

First, I created a copy of the template in vCenter and named it "W2k16-WinRM-Template". I then converted this template into a virtual machine. After starting the VM, I opened the "PowerShell ISE" program. Next, I reviewed a pre-configured script for setting up WinRM HTTP and HTTPS from "https://learn.microsoft.com/". I copied these codes into new scripts in PowerShell ISE and saved them under "C:\Scripts\" as "allow_winrm_http" and "allow_winrm_https". Finally, I shut down the VM and converted it back into a template in vCenter. This process removes all unique IDs, such as MAC addresses, and regenerates them for cloned VMs.

In the test environment, encrypted communication via HTTPS is not necessary. However, I opted to use HTTPS because it is a requirement for the production environment. Thus, a certification authority would need to be set up for the production environment to issue certificates for HTTPS for each VM. The setup of WinRM should occur when creating the VM, as the HTTPS certificate can only be passed at that time. For the test environment, I used a self-signed certificate for WinRM HTTPS, so setting up a certification authority is unnecessary. However, a self-signed certificate is not recommended for the production environment as it cannot be validated by Terraform and Ansible. Thus, even for the test environment, the certificate validation must be ignored by Terraform and Ansible.

**Phase 1: Developing the Code**

Similar to the development of Ansible playbooks, the development of Terraform scripts also follows three phases. In the first phase, I set up the directories for the scripts and developed them with hardcoded values. This is illustrated with the "create_windows_server_2016_vm" example.

First, I created the "main.tf" file in the "Terraform/modules/create_windows_server_2016_vm/" directory. To create a virtual machine in vSphere, we first need system information from vSphere. Then, the "resource" feature is called to create a VM. Besides system information from vSphere, information about the VM itself, such as the number of processors, is needed. The script in the "main.tf" looks as follows:

```hcl
provider "vsphere" {
  user           = "username"
  password       = "password"
  vsphere_server = "vcenter_server"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "datacenter_name"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore_name"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "cluster_name"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "network_name"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "vm_name"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = "windows9Server64Guest"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 60
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name  = "vm_name"
        admin_password = "password"
      }

      network_interface {
        ipv4_address = "ip_address"
        ipv4_netmask = 24
      }

      ipv4_gateway = "gateway"
      dns_server_list = ["dns_server"]
    }
  }
}
```

Similarly, I developed the scripts "wait_for_time_passed", "create_vsphere_folder", "generated_password", and "save_pw_in_file".

**Phase 2: Replacing Code with Variables**

In Phase 2, all hardcoded values are replaced with variables. For system information retrieval, it looks like this:

```hcl
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
```

For the VM creation, it looks like this:

```hcl
resource "vsphere_virtual_machine" "vm" {
  name             = var.server_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.cpu
  memory   = var.ram
  guest_id = "windows9Server64Guest"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = var.disk_space
    eagerly_scrub    = false
    thin_provisioned = var.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name  = var.server_name
        admin_password = var.administrator_password
      }

      network_interface {
        ipv4_address = var.ip_address
        ipv4_netmask = var.netmask
      }

      ipv4_gateway = var.ip_gateway
      dns_server_list = var.dns_server_list
    }
  }
}
```

Next, a "variables.tf" file must be created to declare all variables. For the "create_windows_server_2016_vm" example, the following variables are needed:

- `vsphere_user`
- `vsphere_password`
- `vsphere_server`
- `vsphere_datacenter`
- `vsphere_datastore`
- `vsphere_cluster`
- `vsphere_network`
- `server_name`
- `cpu`
- `ram`
- `thin_provisioned`
- `disk_space`
- `administrator_password`
- `ip_address`
- `netmask`
- `ip_gateway`
- `dns_server_list`

Here's an example for the `dns_domain_name` variable:

```hcl
variable "dns_domain_name" {
  description = "DNS domain name"
  type        = string
}
```

This approach is applied to the other scripts as well.

**Phase 3: Code Compression**

In the final phase, I reviewed whether any compression or additions to the scripts were possible or necessary. For the "create_windows_server_2016_vm" script, no compression or additions were needed. This was also the case for the other scripts.

### Integrating Terraform and Ansible

Important: When integrating Terraform and Ansible, the path specifications must be exact. Any deviations can prevent the scripts and playbooks from being executed. Additionally, Ansible requires an inventory in the form of a "hosts.yml" file, which must be created by Terraform (see below). The necessary Ansible password will be passed to Ansible later by the Terraform script.

To enable Terraform to call Ansible playbooks, new directories must be created in the "Terraform/modules/" directory corresponding to the playbooks. Each new directory should contain a "main.tf" and a "variables.tf". The necessary variables are declared in "variables.tf". In "main.tf", the connections to the Ansible playbooks are established. This is done by letting Terraform execute a local command. For the "create_domain" example, it looks like this:

```hcl
resource "null_resource" "ansible_create_domain" {
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook -i hosts.yml create_domain.yml
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
```

This process is repeated for all Ansible playbooks in Terraform.

###  Creating "main.tf" and "variables.tf" for Test Customers

To use the modular structure for specific customers, I created a "main.tf" and "variables.tf" file in the customer's directory "Customers/168/". In "main.tf", all necessary modules, such as "create_windows_server_2016_vm", are listed. It looks something like this:

```hcl
module "create_windows_server_2016_vm" {
  source            = "../modules/create_windows_server_2016_vm"
  vsphere_user      = var.vsphere_user
  vsphere_password  = var.vsphere_password
  vsphere_server   

 = var.vsphere_server
  vsphere_datacenter= var.vsphere_datacenter
  vsphere_datastore = var.vsphere_datastore
  vsphere_cluster   = var.vsphere_cluster
  vsphere_network   = var.vsphere_network
  server_name       = var.server_name
  cpu               = var.cpu
  ram               = var.ram
  thin_provisioned  = var.thin_provisioned
  disk_space        = var.disk_space
  administrator_password = var.administrator_password
  ip_address        = var.ip_address
  netmask           = var.netmask
  ip_gateway        = var.ip_gateway
  dns_server_list   = var.dns_server_list
}
```

Other modules are called similarly. Some are set as dependencies of others to ensure the correct execution order:

| Module Name                          | Dependency                                      |
|--------------------------------------|-------------------------------------------------|
| generated_administrator_password     | -                                               |
| generated_safe_mode_pw_ad_ds_password| -                                               |
| generated_service_ansible_password   | -                                               |
| generated_service_terraform_password | -                                               |
| generated_default_password           | -                                               |
| save_pw_in_file                      | -                                               |
| create_vsphere_folder                | -                                               |
| create_inventory                     | -                                               |
| create_windows_server_2016_vm        | save_pw_in_file, create_inventory, create_vsphere_folder |
| wait_for_time_passed                 | create_windows_server_2016_vm                   |
| create_domain                        | wait_for_time_passed                            |
| join_domain_as_dc                    | create_domain                                   |
| create_domain_structure              | join_domain_as_dc                               |
| create_user_ansibleservice_and_terraformservice | create_domain_structure                |
| create_user_testuser_and_testadmin   | create_user_ansibleservice_and_terraformservice |
| domain_password_policies             | create_user_testuser_and_testadmin              |

In "variables.tf", all necessary variables are declared. Some variables are assigned default values. For example:

```hcl
variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
}

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
  default     = "vcenter.local"
}
```

Subsequently, I adjusted the module calls for password generation so that passwords are generated automatically if not provided. In the test environment, passwords are saved in a text file and secured in an Ansible Vault. The Ansible Vault password is requested during the execution of the "plan.out" and only after entering this password will the plan continue. The corresponding provider for vSphere is called as follows:

```hcl
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  allow_unverified_ssl = true
}
```

This sets up the customer-specific script for the automatic creation of a domain structure.

Additionally, I created a script "run_manual_config.sh" in the customer's folder:

```bash
#!/bin/bash
terraform init
terraform plan -out plan.out
terraform apply "plan.out"
```

This script facilitates the execution of Terraform.

Finally, I created a script "run_check_for_customer" in the "Automation_v3" folder and a playbook in "Ansible/roles/check_for_customer/". These check whether a customer directory and the files for Terraform exist. If they do not exist, the customer directory is created, and the files are copied from the standard directory. Afterwards, the customer's "variables.tf" must be adjusted.

---

