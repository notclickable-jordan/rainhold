# Overview

Complete guide to set up a secure, automated server environment.

-   Virtualize multiple servers through Proxmox
-   Configure servers automatically using Ansible
-   Mnaage users using OAuth with LDAP and passkey logins
-   Host public sites through Cloudflare
-   Serve private sites safely through custom DNS via Tailscale and NextDNS

# Guide

Follow these steps in order to set up your server environment.

1. [Set variables](docs/variables.md) like your server name, first username, and application secrets
1. [Create a Proxmox hypervisor](docs/proxmox.md) and configure it for Tailscale and SSL
1. [Create a Linux VM](docs/linux-vm.md) in Proxmox and configure it for Ansible
1. [Use Ansible](docs/ansible.md) to configure the Debian VM and its Docker containers
1. [Configure Cloudflare](docs/cloudflare.md) tunnels and DNS for public sites
1. [Shield private sites](docs/private.md) with Tailscale and NextDNS

# Additional documentation

-   [Pocket ID](docs/pocket-id.md): Automatic login to sites using Pocket ID and LLDAP
-   [Apprise](docs/apprise.md): Send notifications to Mastodon and other services
-   [Network share](docs/network-share.md): Mount a network shared folder using SMB/CIFS
-   [Gitea](docs/gitea.md): Get the runner registration token
-   [Grafana](docs/grafana.md): Connect Grafana to Pocket ID for authentication
-   [Caddy](docs/caddy.md): Configure Caddy for reverse proxy and DNS management
-   [Ports](docs/ports.md): All ports and services used in this setup

# Services used

-   [Apprise](https://github.com/caronc/apprise)
-   [Caddy Cloudflare DNS](https://github.com/notclickable-jordan/caddy-cloudflare-dns)
-   [Debian](https://www.debian.org)
-   [Dozzle](https://dozzle.dev)
-   [Miniflux](https://miniflux.app)
-   [Gitea](https://about.gitea.com)
-   [Grafana](https://grafana.com)
-   [Lemmy](https://join-lemmy.org)
-   [LLDAP](https://github.com/lldap/lldap)
-   [Mailrise](https://github.com/yoryan/mailrise)
-   [N8N](https://n8n.io)
-   [Pocket ID](https://github.com/pocket-id/pocket-id)
-   [Proxmox](https://proxmox.com/en/)
-   [Starbase 80](https://github.com/notclickable-jordan/starbase-80)
-   [Tinyauth](https://tinyauth.app)
-   [Watchtower](https://github.com/containrrr/watchtower)
