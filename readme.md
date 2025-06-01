# Overview

Ansible-based automation for provisioning, configuring, and managing Linux servers and application stacks.

- Secure server setup
- SSH hardening
- Security roles (Fail2Ban, Tailscale)
- Designed to spin up public, private, and off-grid servers (beacon, haven, wilds)
- Docker containers with with backup/restore scripts

# Setup local machine

## Install Python 3

Run:

```bash
brew install python
pip3 install --user 'passlib[bcrypt]'
```

## Install Ansible
Run:

```bash
brew install ansible
```

# Setup remote server

## Put SSH key in authorized_keys

Run:

```bash
ssh-copy-id username@ip.address
```

## Install sudo

Run:

```bash
ssh username@ip.address
su -
apt update
apt install sudo
```

## Add your user to sudoers

Run:

```bash
su -
addusers username sudo
```

# Running Ansible

## Encrypting variables

Run:

```bash
ansible-vault encrypt ansible/inventory/host_vars/beacon.yml
```

## Running the playbook

Run:

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user username --inventory ansible/inventory/hosts.yml
```

# Troubleshooting

## Tailscale

If the Tailscale role fails, disable manual device approval in the Tailscale admin console.