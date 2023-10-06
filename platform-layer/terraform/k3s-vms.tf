module "k3s-production" {
  source               = "./modules/k3s-cluster"
  name_prefix          = "k3s-prod-vm"
  net_cidr_prefix      = "192.168.20.0/24"
  net_gateway_addr     = "192.168.20.1"
  net_starting_hostnum = 131
  net_vlan             = 20
  sshkeys              = data.sops_file.tfvars.data["sshkeys"]
  user                 = "brian"
}
