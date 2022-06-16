terraform {
  cloud {
    organization = "bcbrookman"
    workspaces {
      name = "homelab"
    }
  }
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
    sops = {
      source = "carlpett/sops"
    }
  }
}

data "sops_file" "tfvars" {
  source_file = "tfvars.yaml"
}

variable "pm_api_url" {
  sensitive = true
  default = "https://pve:8006/api2/json"
}

variable "pm_api_token_id" {
  sensitive = true
  default = "user@pam!token"
}

variable "pm_api_token_secret" {
  sensitive = true
  default = "token"
}

variable "sshkeys" {
  sensitive = true
  default = "ssh-public-key"
}

provider "proxmox" {
  pm_api_url = data.sops_file.tfvars.data["pm_api_url"]
  pm_api_token_id = data.sops_file.tfvars.data["pm_api_token_id"]
  pm_api_token_secret = data.sops_file.tfvars.data["pm_api_token_secret"]
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "k3s-servers" {
  count = 6
  ciuser = "brian"
  name = "k3s-vm0${count.index + 1}"
  target_node = "pve0${count.index % 3 + 1}"
  clone = "debian-10-genericcloud-amd64-20211011-792-pve0${count.index % 3 + 1}"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  onboot = true
  disk {
    size = "10G"
    type = "scsi"
    storage = "local"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = 20
  }
  ipconfig0 = "ip=192.168.20.13${count.index + 1}/24,gw=192.168.20.1,ip6=auto"
  serial {
    id = 0
    type = "socket"
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      network,
    ]
  }
  sshkeys = data.sops_file.tfvars.data["sshkeys"]
}