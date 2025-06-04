# Remote server

After creating a VM in Proxmox, you need to configure it so Ansible can reach it.

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
