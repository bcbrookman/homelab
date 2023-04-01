resource "proxmox_vm_qemu" "pfsense" {
  count       = 2
  name        = "pfsense0${count.index % 2 + 1}"
  target_node = "pve0${count.index % 2 + 1}"
  full_clone  = false
  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  boot        = "order=ide0;net0"
  qemu_os     = "other"
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      network,
    ]
  }
}
