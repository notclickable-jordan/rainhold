# Overview

Ansible-based automation for provisioning, configuring, and managing Linux servers and application stacks.

-   Secure server setup
-   SSH hardening
-   Security roles (Fail2Ban, Tailscale)
-   Designed to spin up public, private, and off-grid servers (beacon, haven, wilds)
-   Docker containers with with backup/restore scripts

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
ansible-playbook ansible/playbook.yml --ask-become-pass --user jordan --inventory ansible/inventory/hosts.yml
```

# Pocket ID and LLDAP

## Client Configuration

| Field                             | Value                                        |
| --------------------------------- | -------------------------------------------- |
| **LDAP URL**                      | `ldap://100.89.146.30:4201`                  |
| **LDAP Bind DN**                  | `uid=admin,ou=people,dc=notclickable,dc=com` |
| **LDAP Bind Password**            | _(set via UI — use value from `.env`)_       |
| **LDAP Base DN**                  | `dc=notclickable,dc=com`                     |
| **User Search Filter**            | `(objectClass=person)`                       |
| **Groups Search Filter**          | `(objectClass=groupOfNames)`                 |
| **Skip Certificate Verification** | (enabled)                                    |
| **Keep Disabled Users**           | (enabled)                                    |

---

## Attribute Mapping

| Attribute                             | Value               |
| ------------------------------------- | ------------------- |
| **User Unique Identifier Attribute**  | `uuid`              |
| **Username Attribute**                | `user_id`           |
| **User Mail Attribute**               | `mail`              |
| **User First Name Attribute**         | `first_name`        |
| **User Last Name Attribute**          | `last_name`         |
| **User Profile Picture Attribute**    | `avatar`            |
| **Group Members Attribute**           | `member`            |
| **Group Name Attribute**              | `display_name`      |
| **Group Unique Identifier Attribute** | `uuid`              |
| **Admin Group Name**                  | `_admin_group_name` |

# Ports

| Port | Service                | Description                           |
| ---- | ---------------------- | ------------------------------------- |
| 80   | Caddy                  | Web server for HTTP traffic           |
| 443  | Caddy                  | Web server for HTTPS traffic          |
| 4201 | LLDAP                  | LLDAP service (389) for Pocket ID     |
| 4202 | LLDAP Admin UI         | Web interface for LLDAP management    |
| 4203 | Pocket ID              | Pocket ID service for user management |
| 4204 | Dozzle                 | Dozzle service for Docker logs        |
| 4205 | Not Clickable redirect | Redirect Not Clickable to YouTube     |
| 4206 | Tinyauth               | Tinyauth service for authentication   |

# Caddy

Why does Caddy use a personal Docker image? Because, in order to get SSL certificates through Cloudflare, I needed to use a custom build of Caddy. You might not if you're not using Cloudflare.

# Troubleshooting

## Pocket ID

To access the Pocket ID admin interface, visit `https://pocketid.example.com/login/setup`

## Tailscale

If the Tailscale role fails, disable manual device approval in the Tailscale admin console.
