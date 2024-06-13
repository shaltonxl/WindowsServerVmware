# WindowsServerVmware

This repository contains code and configuration files for setting up a Windows infrastructure using Terraform and Ansible.

Project Overview
The objective of this project is to identify and set up a software solution for deploying and configuring virtual infrastructures. This solution should enable both an initial rollout and continuous development of structures based on the concept of Infrastructure as Code (IaC).

Project Goals
The primary goal is to establish a test environment to develop basic scripts. Fundamental scenarios should be implemented within this test environment. At the beginning of the project, it is essential to evaluate the available software on the market. Some examples of IaC tools include Ansible, Chef, Puppet, Salt, and Terraform. Subsequently, a decision matrix will be created to select the appropriate solution, considering certain constraints such as the existing vSphere infrastructure and multi-tenant capabilities. Additionally, further automation for networking and VPN topics will be considered during the software selection.

Decision and Implementation
As a result of this process, we have decided to use Ansible in combination with Terraform. The criteria and decision processes are documented in detail. Following this decision, a test environment will be set up using the chosen software. This involves installing the software with all necessary features on a virtual machine running Ubuntu LTS, which will serve as the controller for the test environment. Scripts developed on this VM will be executed against a test server within a VMware vSphere environment provided by the client.

Script Objectives
The goal of the scripts is to create two virtual machines with a current version of Windows Server. These VMs will be configured as domain controllers for a new domain structure. A domain structure from the production environment will serve as a template for the new domain. The domain will include the basic structure of organizational units (OUs) modeled after the OU structure used in the production environment.

Security Configuration
Important IT security settings will be configured and assigned through group policies, such as password policies. The production environment will also serve as a template here. By using Infrastructure as Code, defined standards and guidelines can be automatically applied to the infrastructure, eliminating the need for later reviews and corrections. The scripts also serve as a form of documentation, enabling quick recovery of a functional infrastructure in case of a total server failure, such as from a cyberattack.

