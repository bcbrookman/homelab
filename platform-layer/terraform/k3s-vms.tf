resource "proxmox_vm_qemu" "k3s-production" {
  count = 5
  ciuser = "brian"
  name = "k3s-prod-vm0${count.index + 1}"
  target_node = "pve0${count.index % 5 + 1}"
  clone = "debian-10-genericcloud-amd64-20211011-792-pve0${count.index % 5 + 1}"
  agent = 1
  os_type = "cloud-init"
  cores = 4
  sockets = 1
  cpu = "host"
  memory = 10240
  scsihw = "virtio-scsi-pci"
  onboot = true
  disk {
    size = "50G"
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

resource "proxmox_vm_qemu" "k3s-staging" {
  count = 5
  ciuser = "brian"
  name = "k3s-staging-vm0${count.index + 1}"
  target_node = "pve0${count.index % 5 + 1}"
  clone = "debian-10-genericcloud-amd64-20211011-792-pve0${count.index % 5 + 1}"
  agent = 1
  os_type = "cloud-init"
  cores = 4
  sockets = 1
  cpu = "host"
  memory = 10240
  scsihw = "virtio-scsi-pci"
  onboot = true
  disk {
    size = "50G"
    type = "scsi"
    storage = "local"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = 20
  }
  ipconfig0 = "ip=192.168.20.14${count.index + 1}/24,gw=192.168.20.1,ip6=auto"
  serial {
    id = 0
    type = "socket"
  }
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [
      network,
    ]
  }
  sshkeys = data.sops_file.tfvars.data["sshkeys"]
}
