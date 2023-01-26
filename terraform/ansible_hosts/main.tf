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
variable "cluster_subdomain" {}
variable "global_lab_domain" {}
variable "agent_public_ips" {}


resource "ansible_host" "ansible_control_plane_servers" {
  count = length(var.control_plane_hosts)
  inventory_hostname = "${element(var.control_plane_hosts, count.index)}.${var.cluster_subdomain}.${var.global_lab_domain}"
  groups = ["all", "k3s_cluster", "k3s_server"]
  vars = {
    ansible_host = element(var.control_plane_public_ips, count.index)
    username = element(var.control_plane_hosts, count.index)

  }
}

resource "ansible_host" "ansible_agent_servers" {
  count = length(var.agent_hosts)
  inventory_hostname = "${element(var.agent_hosts, count.index)}.${var.cluster_subdomain}.${var.global_lab_domain}"
  groups = ["all", "k3s_cluster", "k3s_agent"]
  vars = {
    ansible_host = element(var.agent_public_ips, count.index)
    username = element(var.agent_hosts, count.index)
  }
}



