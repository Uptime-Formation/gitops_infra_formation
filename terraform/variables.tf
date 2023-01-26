variable "control_plane_hosts" {
  default = [
    "cp0",
  ]
}

variable "agent_hosts" {
  default = [
    "agent0",
    "agent1",
    "agent2",
  ]
}

variable "global_lab_domain" {
  default = "dopl.uk"
}

variable "cluster_subdomain" {
  default = "k3lab"
}

variable "hcloud_control_plane_server_type" {
  default = "cx21"
}

variable "hcloud_agent_server_type" {
  default = "cx21"
}