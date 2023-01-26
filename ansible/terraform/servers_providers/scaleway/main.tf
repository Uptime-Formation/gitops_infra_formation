variable "control_plane_hosts" {}
variable "agent_hosts" {}
variable "scaleway_api_secret_key" {}
variable "scaleway_api_access_key" {}
variable "scaleway_orga_id" {}

provider "scaleway" {
  access_key      = var.scaleway_api_access_key
  secret_key      = var.scaleway_api_secret_key
  organization_id = var.scaleway_orga_id
  zone            = "fr-par-1"
  region          = "fr-par"
}

resource "scaleway_instance_ip" "control_plane_servers_ips" {
  count = length(var.control_plane_hosts)
}

resource "scaleway_instance_server" "control_plane_servers" {
  count = length(var.control_plane_hosts)
  name  = "vnc-server-${element(var.control_plane_hosts, count.index)}"
  image = "ubuntu_focal"
  ip_id = element(scaleway_instance_ip.control_plane_servers_ips.*.id, count.index)
  type  = "DEV1-L"
  # scaleway automatically add available ssh keys from the account to every server (no need to do it manually)
}


resource "scaleway_instance_ip" "agent_servers_ips" {
  count = length(var.agent_hosts)
}

resource "scaleway_instance_server" "agent_servers" {
  count = length(var.agent_hosts)
  name  = "vnc-server-${element(var.agent_hosts, count.index)}"
  image = "ubuntu_focal"
  ip_id = element(scaleway_instance_ip.agent_servers_ips.*.id, count.index)
  type  = "DEV1-L"
  # scaleway automatically add available ssh keys from the account to every server (no need to do it manually)
}

resource "scaleway_instance_ip" "guacamole_server_ip" {
}

resource "scaleway_instance_server" "guacamole_server" {
  name  = "guacamole-server"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.guacamole_server_ip.id
  type  = "DEV1-L"
  # scaleway automatically add available ssh keys from the account to every server (no need to do it manually)
}

output "control_plane_public_ips" {
  value = scaleway_instance_ip.control_plane_servers_ips.*.address
}

output "agent_public_ips" {
  value = scaleway_instance_ip.agent_servers_ips.*.address
}

output "guacamole_public_ip" {
  value = scaleway_instance_ip.guacamole_server_ip.address
}