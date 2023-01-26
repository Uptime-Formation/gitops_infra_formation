# ## Ansible mirroring hosts section
# # Using https://github.com/nbering/terraform-provider-ansible/ to be installed manually (third party provider)
# # Copy binary to ~/.terraform.d/plugins/

terraform {
  required_providers {
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
  }
}


# provider "ansible" {
#   # Configuration options
# }

variable "control_plane_hosts" {}
variable "agent_hosts" {}
variable "control_plane_public_ips" {}
variable "agent_public_ips" {}


resource "ansible_host" "ansible_control_plane_servers" {
  count = length(var.control_plane_hosts)
  inventory_hostname = "k3s-${element(var.control_plane_hosts, count.index)}"
  groups = ["all", "k3s_cluster", "k3s_server"]
  vars = {
    ansible_host = element(var.control_plane_public_ips, count.index)
    username = element(var.control_plane_hosts, count.index)
    vpn_ip = "10.111.0.1${count.index}"
  }
}

resource "ansible_host" "ansible_agent_servers" {
  count = length(var.agent_hosts)
  inventory_hostname = "k3s-${element(var.agent_hosts, count.index)}"
  groups = ["all", "k3s_cluster", "k3s_agent"]
  vars = {
    ansible_host = element(var.agent_public_ips, count.index)
    username = element(var.agent_hosts, count.index)
    vpn_ip = "10.111.0.2${count.index}"
  }
}

# resource "ansible_host" "bastion" {
#   inventory_hostname = "guacamole-server"
#   groups = ["all", "scaleway", "guacamole_servers", "wireguard"]
#   vars = {
#     ansible_host = var.guacamole_public_ip
#     guacamole_domain = var.guacamole_domain
#     vpn_ip = "10.111.0.1"
#   }
# }

