resource "proxmox_vm_qemu" "plex01" {
  name = "plex01"
  target_node = "pve04"
  full_clone = false
  agent = 1
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 8192
  balloon = 2048
  scsihw = "virtio-scsi-pci"
  onboot = true
  boot = "order=scsi0;net0"
  disk {
    size = "32G"
    type = "scsi"
    storage = "local"
    iothread = 0
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = 20
  }
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "docker01" {
  name = "docker01"
  target_node = "pve02"
  full_clone = false
  agent = 1
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  onboot = true
  boot = "order=scsi0;net0"
  disk {
    size = "32G"
    type = "scsi"
    storage = "local"
    iothread = 0
    discard = "on"
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = 20
  }
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [
      network,
    ]
  }
}
