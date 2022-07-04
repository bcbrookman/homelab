# Homelab

This repository contains my homelab infrastructure, defined and deployed as code. 

## Overview

In addition to being an infrastructure lab, it also functions as my home network. It supports much of what I do everyday, and is designed with the following goals in mind:

- High service uptime
- High fault tolerance
- Best practice security
- Privacy by design
- Efficient resource utilization
- Low power, noise, and space

## Layers

My homelab is designed in layers which very loosely align with the concepts of SaaS, PaaS, and IaaS. Modularizing the infrastructure in this way helps me isolate dependencies, and avoid deployment problems.

### Infrastructure Layer

The infrastructure layer provides the low-level plumbing and compute resources used by the platform layer. It includes:

- Networking
- Compute hardware
- Bare-metal OS setup
- Environmentals
- Power management

### Platform Layer

The platform layer provides the underlying infrastructure which software and services are deployed on within the software layer. It includes:

- VM and LXC provisioning
- OS configuration management
- Kubernetes clusters

### Software Layer

The software layer provides applications and services to users and other systems in my homelab. It includes: 

- Deployment manifests
- Application setup configs