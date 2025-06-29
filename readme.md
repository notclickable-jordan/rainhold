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
1. [Install a Proxmox hypervisor](docs/proxmox.md) and configure it for Tailscale and SSL
1. [Create a Linux VM](docs/linux-vm.md) in Proxmox and configure it for Ansible
1. [Use Ansible](docs/ansible.md) to configure the Linux VM and its Docker containers
1. [Set up Cloudflare](docs/cloudflare.md) tunnels and DNS for public sites
1. [Shield private sites](docs/private.md) with Tailscale and NextDNS

# Further documentation

-   [Pocket ID](docs/pocket-id.md) provides automatic login to sites using OAuth and LLDAP
-   [Apprise](docs/apprise.md) sends notifications to Mastodon
-   [Network share](docs/network-share.md) instructions for backups and file sharing
-   [Gitea](docs/gitea.md) needs a runner registration token
-   [GitLab](docs/gitlab.md) has things that need to be set manually
-   [Caddy](docs/caddy.md) uses a custom image for Cloudflare DNS
-   [Ports](docs/ports.md) lists all ports numbers used in this setup

# Services used

-   [Ansible](https://www.ansible.com)
-   [Apprise](https://github.com/caronc/apprise)
-   [Audiobookshelf](https://www.audiobookshelf.org)
-   [Caddy Cloudflare DNS](https://github.com/notclickable-jordan/caddy-cloudflare-dns)
-   [Calibre](https://github.com/janeczku/calibre-web)
-   [Cloudflare](https://cloudflare.com)
-   [Debian](https://www.debian.org)
-   [Docker](https://www.docker.com)
-   [Dozzle](https://dozzle.dev)
-   [Gitea](https://about.gitea.com)
-   [Grafana](https://grafana.com)
-   [Jellyfin](https://jellyfin.org)
-   [Lemmy](https://join-lemmy.org)
-   [LLDAP](https://github.com/lldap/lldap)
-   [Loki](https://grafana.com/oss/loki/)
-   [Mailrise](https://github.com/yoryan/mailrise)
-   [Mastodon](https://joinmastodon.org)
-   [Miniflux](https://miniflux.app)
-   [N8N](https://n8n.io)
-   [NextDNS](https://nextdns.io)
-   [Pocket ID](https://github.com/pocket-id/pocket-id)
-   [Prometheus](https://prometheus.io)
-   [Proxmox](https://proxmox.com/en/)
-   [Starbase 80](https://github.com/notclickable-jordan/starbase-80)
-   [Tailscale](https://tailscale.com)
-   [Tinyauth](https://tinyauth.app)
-   [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
-   [Watchtower](https://github.com/containrrr/watchtower)
-   [YTPTube](https://github.com/arabcoders/ytptube)
