module "pgsql-ha" {
  nodes                = 1
  source               = "./modules/pgsql-ha"
  name_prefix          = "pgsql-ct"
  net_cidr_prefix      = "192.168.20.0/24"
  net_gateway_addr     = "192.168.20.1"
  net_starting_hostnum = 141
  net_vlan             = 20
  initial_root_pw      = data.sops_file.tfvars.data["pgsql_initial_root_password"]
  sshkeys              = data.sops_file.tfvars.data["sshkeys"]
}
