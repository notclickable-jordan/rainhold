# Proxmox

## Installation

1. **Install Proxmox from USB**

    - **Hostname:** `example.domain.com` (the `example` part becomes the node name in Tailscale)
    - **IP Address:** `ip.address/24`
    - **Gateway:** `router.ip.address`
    - **DNS Server:** `router.ip.address`

2. **Repositories**

    - Navigate to `Datacenter > home > Repositories`
    - Disable all repositories starting with `enterprise.proxmox`

3. **Download Debian ISO**

    - Go to `Datacenter > home > local > ISO Images`
    - Add from URL:  
      `https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-12.11.0-amd64-DVD-1.iso`

4. **Create VM and Install**
    - Make sure the VM disk is stored in the correct location.
    - Avoid creating custom storage folders.

---

## Tailscale Setup

1. **Install Tailscale**

    - Navigate to `Datacenter > home > Shell`
    - Run:
        ```bash
        curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
        curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
        apt-get update
        apt-get install tailscale
        ```

2. **Authenticate Tailscale**
    ```bash
    tailscale up
    ```

---

## Tailscale SSL

1. **Create script at `/root/tailscale-ssl.sh`:**

    ```bash
    #!/bin/bash
    NAME="$(tailscale status --json | jq '.Self.DNSName | .[:-1]' -r)"
    tailscale cert "${NAME}"
    pvenode cert set "${NAME}.crt" "${NAME}.key" --force --restart
    ```

2. **Run manually at first**, then make it executable and schedule via cron:

    ```bash
    chmod +x ./tailscale-ssl.sh
    crontab -e
    ```

3. **Add to crontab:**

    ```cron
    0 1 * * * /root/tailscale-ssl.sh
    ```

4. **Check Proxmox URL (example):**  
   `https://example.tail6e07a.ts.net:8006`

---

## System Updates

1. **Connect via shell:**
    ```bash
    apt-get update
    apt-get upgrade
    ```

---

## User Setup

1. **Create personal user:**

    ```bash
    adduser username
    ```

2. **Set up SSH key login:**

    ```bash
    ssh-copy-id username@server
    ```

3. **Disable password authentication:**
    - Edit `/etc/ssh/sshd_config`
    - Search for `PasswordAuthentication`, uncomment and set to `no`
    - Restart SSH:
        ```bash
        systemctl restart sshd
        ```

---

## Enable Automatic Updates

1. **Install unattended upgrades:**

    ```bash
    apt update
    apt install unattended-upgrades
    dpkg-reconfigure --priority=low unattended-upgrades
    ```

2. **Edit auto-clean interval:**

    ```bash
    nano /etc/apt/apt.conf.d/20auto-upgrades
    ```

    Add:

    ```conf
    APT::Periodic::AutocleanInterval "21";
    ```

---

## Synology NAS

1. Navigate to `Datacenter > Storage`
2. Add SMB/CIFS with the following:
    - **Server:** `ip.address`
    - **Share:** `home` (or other shared folder)
    - **Content:** `VZDump backup file`
