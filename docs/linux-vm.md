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
    - If it asks if you want to install mirrors, select `Yes`
    - For software selection, uncheck everything except `SSH server` and `standard system utilities`
    - Once it's installed, get the IP address of your Linux VM from your router. Proxmox does not tell you the IP address of the VM. You'll need this for the Ansible step below.

After creating a Linux VM in Proxmox, you need to configure it so Ansible can reach it.

# Configure the Linux VM for Ansible

## Put your SSH key in authorized_keys

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
adduser strongbad sudo
```

# Update Ansible inventory

1. Open `ansible/inventory/hosts.yml`
1. Update `ansible_host` to your Linux VM's IP address

# Troubleshooting

## Unable to install Tailscale

This may be because of missing sources in Debian. To fix this:

1. Open `/etc/apt/sources.list` in your Linux VM
1. Add the following lines to the end of the file:
    ```
    deb http://deb.debian.org/debian bookworm main contrib non-free
    deb-src http://deb.debian.org/debian bookworm main contrib non-free
    deb http://security.debian.org/debian-security bookworm-security main contrib non-free
    deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free
    ```
1. Save the file
1. Run the following commands:
    ```bash
    apt update
    apt upgrade
    ```

---

-   **Previous step:** [Create a Proxmox hypervisor](./proxmox.md) and configure it for Tailscale and SSL
-   **Next step:** [Use Ansible](./ansible.md) to configure the Linux VM and its Docker containers
