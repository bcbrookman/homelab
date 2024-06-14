terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

variable "cores" {
  type    = number
  default = 4
}

variable "disk_size" {
  type    = string
  default = "50G"
}

variable "memory" {
  type    = number
  default = 4096
}

variable "nodes" {
  type    = number
  default = 3
}

variable "name_prefix" {
  type = string
}

variable "net_cidr_prefix" {
  type = string
}

variable "net_gateway_addr" {
  type = string
}

variable "net_starting_hostnum" {
  type = number
}

variable "net_vlan" {
  type = number
}

variable "sshkeys" {
  type      = string
  sensitive = true
}

locals {
  net_cidr_mask = split("/", var.net_cidr_prefix)[1]
}


resource "proxmox_lxc" "pgsql-ct" {
  count           = var.nodes
  cores           = var.cores
  memory          = var.memory
  target_node     = "pve0${count.index % var.nodes + 1}"
  hostname        = "${var.name_prefix}0${count.index + 1}"
  ostemplate      = "nas:vztmpl/debian-12-turnkey-postgresql_18.0-1_amd64.tar.gz"
  onboot          = true
  unprivileged    = true
  ssh_public_keys = var.sshkeys
  rootfs {
    storage = "local-lvm"
    size    = var.disk_size
  }
  network {
    name   = "eth0"
    bridge = "vmbr0"
    tag    = 20
    ip     = "${cidrhost(var.net_cidr_prefix, var.net_starting_hostnum + count.index)}/${local.net_cidr_mask}"
    gw     = var.net_gateway_addr
  }
  lifecycle {
     prevent_destroy = true
  }
}
