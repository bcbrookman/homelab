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
  default = 10240
}

variable "nodes" {
  type    = number
  default = 5
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

variable "user" {
  type      = string
  sensitive = true
}

locals {
  net_cidr_mask   = split("/", var.net_cidr_prefix)[1]
  clone_vm_prefix = "debian-10-genericcloud-amd64-20211011-792"
}

resource "proxmox_vm_qemu" "k3s-vm" {
  count       = var.nodes
  ciuser      = var.user
  name        = "${var.name_prefix}0${count.index + 1}"
  target_node = "pve0${count.index % var.nodes + 1}"
  clone       = "${local.clone_vm_prefix}-pve0${count.index % var.nodes + 1}"
  full_clone  = true
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.cores
  sockets     = 1
  cpu         = "host"
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  disk {
    size    = var.disk_size
    type    = "scsi"
    storage = "local-lvm"
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 20
  }
  ipconfig0 = join(",",
    [
      "ip=${cidrhost(var.net_cidr_prefix, var.net_starting_hostnum + count.index)}/${local.net_cidr_mask}",
      "gw=${var.net_gateway_addr}"
    ]
  )
  serial {
    id   = 0
    type = "socket"
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      network,
    ]
  }
  sshkeys = var.sshkeys
}
