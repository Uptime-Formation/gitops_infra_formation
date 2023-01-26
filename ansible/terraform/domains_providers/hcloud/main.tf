
variable "hcloud_dns_token" {}

variable "cluster_subdomain" {}

variable "control_plane_hosts" {}
variable "agent_hosts" {}
variable "control_plane_public_ips" {}
variable "agent_public_ips" {}


terraform {
  required_providers {
    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "2.1.0"
    }
  }
}

provider "hetznerdns" {
  # Configuration options
  apitoken = var.hcloud_dns_token
}


data "hetznerdns_zone" "dopluk" {
    name = "dopl.uk"
}

resource "hetznerdns_record" "control_plane_subdomains" {
  count = length(var.control_plane_hosts)
  zone_id = data.hetznerdns_zone.dopluk.id
  type   = "A"
  ttl = 3600
  name   = try("${element(var.control_plane_hosts, count.index)}.${var.cluster_subdomain}", "")
  value  = try(element(var.control_plane_public_ips, count.index), "")
}

resource "hetznerdns_record" "control_plane_wildcard_subdomains" {
  count = length(var.control_plane_hosts)
  zone_id = data.hetznerdns_zone.dopluk.id
  type   = "A"
  ttl = 3600
  name   = try("*.${element(var.control_plane_hosts, count.index)}.${var.cluster_subdomain}", "")
  value  = try(element(var.control_plane_public_ips, count.index), "")
}

resource "hetznerdns_record" "agent_subdomains" {
  count = length(var.agent_hosts)
  zone_id = data.hetznerdns_zone.dopluk.id
  type   = "A"
  ttl = 3600
  name   = try("${element(var.agent_hosts, count.index)}.${var.cluster_subdomain}", "")
  value  = try(element(var.agent_public_ips, count.index), "")
}

resource "hetznerdns_record" "agent_wildcard_subdomains" {
  count = length(var.agent_hosts)
  zone_id = data.hetznerdns_zone.dopluk.id
  type   = "A"
  ttl = 3600
  name   = try("*.${element(var.agent_hosts, count.index)}.${var.cluster_subdomain}", "")
  value  = try(element(var.agent_public_ips, count.index), "")
}