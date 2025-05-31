# Setup

## Put SSH key in authorized_keys

Run:

```bash
ssh-copy-id jordan@192.168.1.57
```

## Install sudo

Run:

```bash
ssh jordan@ip
su -
apt update
apt install sudo
```

## Add your user to sudoers

Run:

```bash
su -
addusers jordan sudo
```

## Install Python 3

On your Mac, run:

```bash
brew install python
pip3 install --user 'passlib[bcrypt]'
```

# Ansible

## Encrypting variables

Run:

```bash
ansible-vault encrypt ansible/inventory/host_vars/beacon.yml
```

## Running playbooks

Run the playbook:

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user jordan --inventory ansible/inventory/hosts.ini
```

# Troubleshooting

## Tailscale

If the Tailscale role fails, disable manual dvice approval in the Tailscale admin console.