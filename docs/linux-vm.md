# Linux virtual machine

In Proxmox:

1. Download Debian ISO
    - Go to `Datacenter > strongserver > local > ISO Images`
    - Add from URL (or latest from [Debian](https://www.debian.org/distrib/)):
        ```
        https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-12.11.0-amd64-DVD-1.iso
        ```
1. Create VM and install
    - Use the Linux VM name and first username you set in [variables](docs/variables.md)
    - Once it's installed, get the IP address of your Linux VM from your router. Proxmox does not tell you the IP address of the VM. You'll need this for the Ansible step below.

After creating a Linux VM in Proxmox, you need to configure it so Ansible can reach it.

# Configure the Linux VM for Ansible

## Put your SSH key in authorized_keys

Run:

```bash
ssh-copy-id strongbad@compy386
```

## Install sudo

Run:

```bash
ssh strongbad@compy386
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

# Update Ansible inventory

1. Open `ansible/inventory/hosts.yml`
1. Update `ansible_host` to your Linux VM's IP address

---

-   **Previous step:** [Create a Proxmox hypervisor](./proxmox.md) and configure it for Tailscale and SSL
-   **Next step:** [Use Ansible](./ansible.md) to configure the Linux VM and its Docker containers
