# Overview

Complete guide to set up a secure, automated server environment.

## Virtualization stack

1. Proxmox VE
2. Debian 12 (Bookworm)
3. Docker

## Connectivity stack

1. Tailscale
2. Cloudflare

## Authentication stack

1. Lightweight LDAP (LLDAP)
2. Pocket ID (Authentication)
3. Tinyauth (Authorization)
4. Caddy (Reverse proxy)

# Goal

I wanted to have a server that mixed public and private sites. Users should be managed through LDAP and have a good user experience. Tailscale provides private access and Cloudflare for SSL certificates and public access.

# Documentation

-   [Proxmox VE](docs/proxmox.md): Initial setup of virtualization platform
-   [Remote computer](docs/remote.md): Initial set up VM created on Proxmox
-   [Local computer](docs/local.md): Local computer setup for Ansible deployment
-   [Cloudflare](docs/cloudflare.md): DNS and SSL management
-   [Ansible](docs/ansible.md): Ansible playbooks for automated deployment
-   [Pocket ID](docs/pocket-id.md): Connecting Pocket ID to LLDAP for user management
-   [Caddy](docs/caddy.md): Using a special build of Caddy for SSL with Cloudflare
-   [Troubleshooting](docs/troubleshooting.md): Common issues and solutions

# Ports and services

| Port    | Service                | Description                           |
| ------- | ---------------------- | ------------------------------------- |
| 80, 443 | Caddy                  | Web server for HTTP traffic           |
| 4201    | LLDAP                  | LLDAP service (389) for Pocket ID     |
| 4202    | LLDAP Admin UI         | Web interface for LLDAP management    |
| 4203    | Pocket ID              | Pocket ID service for user management |
| 4204    | Dozzle                 | Dozzle service for Docker logs        |
| 4205    | Not Clickable redirect | Redirect Not Clickable to YouTube     |
| 4206    | Tinyauth               | Tinyauth service for authentication   |
