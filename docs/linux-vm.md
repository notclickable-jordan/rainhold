# Linux virtual machine

After creating a Debian VM in Proxmox, you need to configure it so Ansible can reach it.

## Put SSH key in authorized_keys

Run:

```bash
ssh-copy-id strongbad@ip.address
```

## Install sudo

Run:

```bash
ssh strongbad@ip.address
su -
apt update
apt install sudo
```

## Add your user to sudoers

Run:

```bash
su -
addusers strongbad sudo
```
