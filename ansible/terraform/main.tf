variable "hcloud_token" {}
variable "digitalocean_token" {}
variable "hcloud_dns_token" {}

module "servers" {
  source = "./servers_providers/hcloud"

  hcloud_token              = var.hcloud_token
  cluster_subdomain         = var.cluster_subdomain
  control_plane_hosts       = var.control_plane_hosts
  agent_hosts               = var.agent_hosts
  control_plane_server_type = var.hcloud_control_plane_server_type
  agent_server_type         = var.hcloud_agent_server_type
}

# module "domains" {
#   source                    = "./domains_providers/hcloud"
#   hcloud_dns_token          = var.hcloud_dns_token
#   cluster_subdomain         = var.cluster_subdomain
#   control_plane_hosts       = var.control_plane_hosts
#   agent_hosts               = var.agent_hosts
#   control_plane_public_ips  = module.servers.control_plane_public_ips
#   agent_public_ips          = module.servers.agent_public_ips
# }

module "domains" {
  source                    = "./domains_providers/digital_ocean"
  digitalocean_token        = var.digitalocean_token
  cluster_subdomain         = var.cluster_subdomain
  control_plane_hosts       = var.control_plane_hosts
  agent_hosts               = var.agent_hosts
  control_plane_public_ips  = module.servers.control_plane_public_ips
  agent_public_ips          = module.servers.agent_public_ips
}


module "ansible_hosts" {
  source                    = "./ansible_hosts"
  control_plane_hosts       = var.control_plane_hosts
  agent_hosts               = var.agent_hosts
  control_plane_public_ips  = module.servers.control_plane_public_ips
  agent_public_ips          = module.servers.agent_public_ips
}