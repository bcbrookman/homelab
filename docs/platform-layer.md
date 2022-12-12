# Platform Layer

This layer provides the environment and runtimes which applications and services are deployed on. In other words, it provides the Kubernetes clusters and database management systems consumed by the software layer.

![layers](assets/homelab-layers-pf.svg)

## Environments

Two environments are defined in the platform-layer: a **staging** environment, and a **production** environment.

While possibly overkill for a homelab, having a pre-production staging environment provides a little extra confidence that software upgrades won't break things. From a learning perspective, promoting changes through lower environments also better replicates real-world deployments.

## Terraform

As with the infrastructure layer, virtual machines are intially provisioned on Proxmox using Terraform. The base Terraform configuration files are symlinked to the infrastructure layer.

VMs can be provisioned using `terraform apply`.

```
cd ./platform-layer/terraform
terraform apply
```

The `-target` option can also be added to limit the scope of the `apply`. This can be useful when needing to apply changes to a subset of resource at a time. For example, when changing K8s nodes.

```
cd ./platform-layer/terraform
terraform apply -target=-k3s-staging[0] -target=k3s-staging[1]
```

## Ansible

Much like the Terraform files in this layer, Ansible playbooks which apply base configurations are symlinked to the infrastructure layer.

The Ansible inventory is split by environment within `./platform-layer/ansible/inventory/`. Using two separate inventory files instead of groups is mainly done to utilize the k3s-ansible sub-module for provisioning K3s. Unfortunately, the k3s-ansible project isn't organized as an Ansible role or collection so it can't be easily integrated into an inventory with multiple environments.

A main.yaml playbook is provided to upgrade installed packages and apply all base configurations. It can be used against staging environment hosts as follows.

```
cd ./platform-layer/ansible/
ansible-playbook -i inventory/staging/ playbooks/main.yaml -K
```

To then configure a K3s cluster on nodes in the staging environment, use the playbook provided by k3s-ansible.

```
ansible-playbook -i inventory/staging/ k3s-ansible/site.yml -K
```
