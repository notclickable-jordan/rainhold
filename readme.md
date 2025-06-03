# Overview

Complete guide to set up a secure, automated server environment. Users are managed through LDAP and use Passkeys to sign in. Public sites are served from Cloudflare. Private sites go through custom DNS via Tailscale.

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

# Documentation

-   [Proxmox VE](docs/proxmox.md): Create virtualization platform
-   [Remote computer](docs/remote.md): Configure VM created on Proxmox
-   [Local computer](docs/local.md): Use a Mac for Ansible deployment
-   [Cloudflare](docs/cloudflare.md): Manage DNS and SSL for public sites
-   [Private sites](docs/private.md): Set up private sites with Tailscale and NextDNS
-   [Ansible](docs/ansible.md): Run Ansible playbooks for automated deployment
-   [Pocket ID](docs/pocket-id.md): Connect Pocket ID to LLDAP for user management
-   [Caddy](docs/caddy.md): Use a special build of Caddy for SSL with Cloudflare
-   [Troubleshooting](docs/troubleshooting.md): Fix common issues and solutions
-   [Ports](docs/ports.md): All ports and services used in this setup
