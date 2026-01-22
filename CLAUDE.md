# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Rainhold is an infrastructure-as-code repository for deploying a self-hosted server environment. It uses Ansible to configure a Debian VM running on Proxmox, with Docker containers for various services (Mastodon, Lemmy, Gitea, Jellyfin, etc.).

## Commands

### Run the full Ansible playbook
```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user <username> --inventory ansible/inventory/hosts.yml
```

### Run a specific playbook
```bash
ansible-playbook ansible/web-server.yml --ask-become-pass --user <username> --inventory ansible/inventory/hosts.yml
```

### Backup Docker volumes (run on server)
```bash
/etc/rainhold/stacks/beacon/backup.sh
```

### Restore Docker volumes (run on server)
```bash
/etc/rainhold/stacks/beacon/restore.sh [YYYY-MM-DD]
```

## Architecture

### Directory Structure

- `ansible/` - Ansible configuration
  - `playbook.yml` - Main entry point, imports `initial-setup.yml` and `web-server.yml`
  - `inventory/hosts.yml` - Target hosts (uses Tailscale IP)
  - `inventory/host_vars/<hostname>.yml` - Per-host secrets (gitignored, copy from `sample.yml`)
  - `roles/` - Modular Ansible roles for each component

- `stacks/beacon/` - Docker stack for the "beacon" server
  - `docker/` - Each subdirectory is a Docker Compose stack with `compose.yml`
  - `backup.sh`, `restore.sh`, `volumes.sh` - Volume backup/restore scripts

### Key Variables

All secrets and configuration are in `ansible/inventory/host_vars/<hostname>.yml`. The file `sample.yml` is a template. Key variables:
- `rainhold_dest` - Installation path on server (default: `/etc/rainhold`)
- `rainhold_stack` - Stack name matching `stacks/<name>/` (e.g., `beacon`)

### Ansible Roles

Roles are split between `initial-setup.yml` (base system) and `web-server.yml` (applications):

**Initial setup:** apt-update, tailscale, fail2ban, unattended-upgrades, ssh-hardening, root-password, network-share, docker-install, cloudflared

**Web server:** postfix, dovecot, nftables-logging, clone-repository, schedule-backup, docker-network, docker-env, docker-start, docker-restart-on-boot, mastodon-feeds

### Docker Stack Pattern

Each service in `stacks/beacon/docker/` follows the same pattern:
- `compose.yml` - Docker Compose file (not `docker-compose.yml`)
- `.env` files are templated by `docker-env` role from Ansible variables
- All containers join the `caddy` external network for reverse proxy access

### Networking

- Caddy handles reverse proxy with automatic HTTPS via Cloudflare DNS
- All Docker services share the `caddy` network (created by `docker-network` role)
- Public sites use Cloudflare tunnels
- Private sites use Tailscale + NextDNS
