
variable "digitalocean_token" {}

variable "cluster_subdomain" {}
variable "global_lab_domain" {}

variable "control_plane_hosts" {}
variable "agent_hosts" {}
variable "control_plane_public_ips" {}
variable "agent_public_ips" {}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.25.2"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

data "digitalocean_domain" "dopluk_domain" {
  name = var.global_lab_domain
}

resource "digitalocean_record" "control_plane_subdomains" {
  count = length(var.control_plane_hosts)
  domain = data.digitalocean_domain.dopluk_domain.name
  type   = "A"
  name   = "${element(var.control_plane_hosts, count.index)}.${var.cluster_subdomain}"
  value  = element(var.control_plane_public_ips, count.index)
}

resource "digitalocean_record" "control_plane_wildcard_subdomains" {
  count = length(var.control_plane_hosts)
  domain = data.digitalocean_domain.dopluk_domain.name
  type   = "A"
  name   = "*.${element(var.control_plane_hosts, count.index)}.${var.cluster_subdomain}"
  value  = element(var.control_plane_public_ips, count.index)
}

resource "digitalocean_record" "agent_subdomains" {
  count = length(var.agent_hosts)
  domain = data.digitalocean_domain.dopluk_domain.name
  type   = "A"
  name   = "${element(var.agent_hosts, count.index)}.${var.cluster_subdomain}"
  value  = element(var.agent_public_ips, count.index)
}

resource "digitalocean_record" "agent_wildcard_subdomains" {
  count = length(var.agent_hosts)
  domain = data.digitalocean_domain.dopluk_domain.name
  type   = "A"
  name   = "*.${element(var.agent_hosts, count.index)}.${var.cluster_subdomain}"
  value  = element(var.agent_public_ips, count.index)
}
