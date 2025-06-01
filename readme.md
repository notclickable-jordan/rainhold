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
pip3.9 install ansible
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

## Authentik first user

In case you can't login anymore, perhaps due to an incorrectly configured stage or a failed flow import, you can create a recovery key.

To create the key, run the following command:

``` bash
docker compose run --rm server create_recovery_key 1 akadmin
```

This will output a link that can be used to instantly gain access to authentik as the user specified above. The link is valid for amount of years specified above, in this case, 1 year.