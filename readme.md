# Overview

Complete guide to set up a secure, automated server environment.

-   Virtualize multiple servers through Proxmox
-   Automatic server setup using Ansible
-   Manage users using OAuth with LDAP and passkey logins
-   Host public sites through Cloudflare
-   Serve private sites through custom DNS via Tailscale and NextDNS

# Guide

Follow these steps to set up your server environment.

1. [Set variables](docs/variables.md) like your server name, first username, and application secrets
1. [Create a Proxmox hypervisor](docs/proxmox.md) and configure it for Tailscale and SSL
1. [Create a Linux VM](docs/linux-vm.md) in Proxmox and configure it for Ansible
1. [Use Ansible](docs/ansible.md) to configure the Linux VM and its Docker containers
1. [Set up Cloudflare](docs/cloudflare.md) tunnels and DNS for public sites
1. [Shield private sites](docs/private.md) with Tailscale and NextDNS

# Further documentation

-   [Pocket ID](docs/pocket-id.md) provides automatic login to sites using OAuth and LLDAP
-   [Apprise](docs/apprise.md) sends notifications to Mastodon
-   [Network share](docs/network-share.md) instructions for backups and file sharing
-   [Gitea](docs/gitea.md) needs a runner registration token
-   [Caddy](docs/caddy.md) uses a custom image for Cloudflare DNS
-   [Ports](docs/ports.md) lists all ports numbers used in this setup

# Services used

-   [Apprise](https://github.com/caronc/apprise)
-   [Caddy Cloudflare DNS](https://github.com/notclickable-jordan/caddy-cloudflare-dns)
-   [Debian](https://www.debian.org)
-   [Dozzle](https://dozzle.dev)
-   [Gitea](https://about.gitea.com)
-   [Grafana](https://grafana.com)
-   [Lemmy](https://join-lemmy.org)
-   [LLDAP](https://github.com/lldap/lldap)
-   [Mailrise](https://github.com/yoryan/mailrise)
-   [Miniflux](https://miniflux.app)
-   [N8N](https://n8n.io)
-   [Pocket ID](https://github.com/pocket-id/pocket-id)
-   [Proxmox](https://proxmox.com/en/)
-   [Starbase 80](https://github.com/notclickable-jordan/starbase-80)
-   [Tinyauth](https://tinyauth.app)
-   [Watchtower](https://github.com/containrrr/watchtower)
