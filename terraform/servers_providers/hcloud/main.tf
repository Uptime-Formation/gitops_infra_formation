variable "hcloud_token" {}

variable "cluster_subdomain" {}
variable "global_lab_domain" {}
variable "control_plane_hosts" {}
variable "agent_hosts" {}
variable "control_plane_server_type" {}
variable "agent_server_type" {}

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.23.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "control_plane_servers" {
  count = length(var.control_plane_hosts)
  name  = "${element(var.control_plane_hosts, count.index)}.${var.cluster_subdomain}.${var.global_lab_domain}"
  server_type = var.control_plane_server_type
  image = "ubuntu-20.04"
  location = "hel1"
  ssh_keys = ["id-guacamole-infra"]
}

resource "hcloud_server" "agent_servers" {
  count = length(var.agent_hosts)
  name  = "${element(var.agent_hosts, count.index)}.${var.cluster_subdomain}.${var.global_lab_domain}"
  server_type = var.agent_server_type 
  image = "ubuntu-20.04"
  location = "hel1"
  ssh_keys = ["id-guacamole-infra"]
}


output "control_plane_public_ips" {
  value = hcloud_server.control_plane_servers.*.ipv4_address
}

output "agent_public_ips" {
  value = hcloud_server.agent_servers.*.ipv4_address
}
