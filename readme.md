# Setup

## Put SSH key in authorized_keys

Run (local):

```bash
ssh-copy-id jordan@192.168.1.57
```

## Install sudo

Run (local/remote):

```bash
ssh jordan@ip
su -
apt update
apt install sudo
```

## Add your user to sudoers

Run (remote):

```bash
su -
addusers jordan sudo
```

## Install Python 3

Run (local)

```bash
brew install python
pip3 install --user 'passlib[bcrypt]'
```

# Ansible

## Encrypting variables

Run (local):

```bash
ansible-vault encrypt ansible/inventory/host_vars/beacon.yml
```

## Running the playbook

Run (local):

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user jordan --inventory ansible/inventory/hosts.yml
```

# Troubleshooting

## Tailscale

If the Tailscale role fails, disable manual device approval in the Tailscale admin console.