# Copilot Instructions

## What This Is

Rainhold is an infrastructure-as-code repository for deploying a self-hosted server environment. It uses **Ansible** to provision a Debian VM running on Proxmox, then deploys ~15 Docker services behind a Caddy reverse proxy. There is no application source code, no build system, and no tests.

## Running the Ansible Playbook

Full playbook (runs both initial setup and web server configuration):

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user <username> --inventory ansible/inventory/hosts.yml
```

Test a single role by editing `ansible/test.yml` to reference the role, then:

```bash
ansible-playbook ansible/test.yml --ask-become-pass --user <username> --inventory ansible/inventory/hosts.yml
```

## Architecture

### Two-phase Ansible playbook

`ansible/playbook.yml` imports two playbooks in order:

1. **`initial-setup.yml`** — OS-level configuration: apt updates, Tailscale VPN, Fail2Ban, SSH hardening, root password, network shares, Docker install, Cloudflare tunnel
2. **`web-server.yml`** — Application-level setup: Postfix/Dovecot mail, nftables firewall, cloning this repo to the server, backup scheduling, Docker networking, `.env` file generation from templates, starting all containers

### Secrets flow

All secrets live in `ansible/inventory/host_vars/<hostname>.yml` (gitignored). The `sample.yml` file is the template. The `docker-env` role uses Jinja2 templates (`ansible/roles/docker-env/templates/`) to generate `.env` files from these variables, deployed with mode `0600`.

### Docker service pattern

Each service lives in `stacks/<stack>/docker/<service>/` with its own `compose.yml`. All services join an external `caddy` bridge network for reverse proxying. The `docker-start` role iterates every subdirectory looking for `compose.yml` and runs `docker compose up -d`.

### Backup system

`stacks/<stack>/volumes.sh` defines all named Docker volumes in `VOLUME_NAME:MOUNT_PATH` format. `backup.sh` tars each volume individually and moves backups to a network share with 7-day retention. `restore.sh` handles recovery. A cron job (via `schedule-backup` role) runs backups daily at 1 AM.

## Conventions

- Docker Compose files are named `compose.yml` (not `docker-compose.yml`)
- Every container uses `restart: unless-stopped`
- Memory limits are set via `deploy.resources.limits.memory` on all containers
- Ansible host variables use a `service_variable` naming pattern (e.g., `mastodon_postgres_password`, `lemmy_db_password`)
- The repo is cloned to the server at the path defined by `rainhold_dest` (default: `/etc/rainhold`)
- The stack name comes from `rainhold_stack` in the inventory (e.g., `beacon`)
