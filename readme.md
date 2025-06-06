# Overview

Complete guide to set up a secure, automated server environment. Users are managed through LDAP and use Passkeys to sign in. Public sites are served from Cloudflare. Private sites go through custom DNS via Tailscale.

## Virtualization stack

1. Proxmox VE
2. Debian 12 (Bookworm)
3. Docker

## Connectivity stack

1. Tailscale
2. Cloudflare
3. NextDNS

## Authentication stack

1. Lightweight LDAP (users and groups)
2. Pocket ID (Authentication)
3. Tinyauth (Authorization)
4. Caddy (Reverse proxy)

# Guide

Follow these steps in order to set up your server environment:

1. [Variables](docs/variables.md): Set up your server name and first username
1. [Proxmox VE](docs/proxmox.md): Create virtualization platform
1. [Remote computer](docs/remote.md): Configure VM created on Proxmox
1. [Cloudflare](docs/cloudflare.md): Manage DNS and SSL for public sites
1. [Private sites](docs/private.md): Set up private sites with Tailscale and NextDNS
1. [Ansible](docs/ansible.md): Run Ansible playbooks for automated deployment

# Additional documentation

-   [Pocket ID](docs/pocket-id.md): Connect Pocket ID to LLDAP for user management
-   [Caddy](docs/caddy.md): Use a special build of Caddy for SSL with Cloudflare
-   [Apprise](docs/apprise.md): Send notifications to Mastodon and other services
-   [Network share](docs/network-share.md): Mount a network shared folder using SMB/CIFS
-   [Gitea](docs/gitea.md): Get the runner registration token
-   [Tailscale](docs/tailscale.md): Set up Tailscale for secure private networking
-   [Ports](docs/ports.md): All ports and services used in this setup

# Sites hosted

-   [Caddy Cloudflare DNS](https://github.com/jordanroher/caddy-cloudflare-dns)
-   [Dozzle](https://dozzle.dev)
-   [Gitea](https://about.gitea.com)
-   [LLDAP](https://github.com/lldap/lldap)
-   [Mailrise](https://github.com/yoryan/mailrise)
-   [Pocket ID](https://github.com/pocket-id/pocket-id)
-   [Starbase 80](https://github.com/jordanroher/starbase-80)
-   [Tinyauth](https://tinyauth.app)
-   [Watchtower](https://github.com/containrrr/watchtower)
