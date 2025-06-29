# Proxmox installation

1. Install Proxmox from USB
    - **Hostname:** `compy386.domain.com` (the `compy386` part becomes the node name in Tailscale, so consider it carefully)
    - **IP Address:** `ip.address/24` (ip.address should be what you want to use for your Proxmox server)
    - **Gateway:** `router.ip.address`
    - **DNS Server:** `router.ip.address`
2. Repositories
    - Navigate to `Datacenter > compy386 > Repositories`
    - Disable all repositories starting with `enterprise.proxmox`

# Tailscale

1. Install Tailscale
    - Navigate to `Datacenter > compy386 > Shell`
    - Run:
        ```bash
        curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
        curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
        apt update
        apt install tailscale
        ```
2. Authenticate Tailscale
    ```bash
    tailscale up
    ```

# System Updates

1. Connect to your server
    ```bash
    ssh root@compy386
    <enter root password>
    ```
2. Update the system
    ```bash
    apt update
    apt upgrade
    ```

# User Setup

1. Install sudo
    ```bash
    apt install sudo
    ```
1. Create personal user
    ```bash
    adduser strongbad
    adduser strongbad sudo
    ```
1. Exit your session
    ```bash
    exit
    ```
1. Set up SSH key login
    ```bash
    ssh-copy-id strongbad@server
    ```
1. Log in with your SSH key
    ```bash
    ssh strongbad@compy386
    ```
1. Disable password authentication
    - Edit `/etc/ssh/sshd_config`
    - Search for `PasswordAuthentication`, uncomment and set to `no`
    - Restart SSH:
        ```bash
        systemctl restart sshd
        ```

## SSL

1. Install jq for JSON parsing
    ```bash
    apt install jq
    ```
1. Create script at `/root/tailscale-ssl.sh`
    ```bash
    #!/bin/bash
    NAME="$(tailscale status --json | jq '.Self.DNSName | .[:-1]' -r)"
    tailscale cert "${NAME}"
    pvenode cert set "${NAME}.crt" "${NAME}.key" --force --restart
    ```
1. Make it executable, run it once manually, then schedule via cron
    ```bash
    chmod +x ./tailscale-ssl.sh
    sudo ./tailscale-ssl.sh
    crontab -e
    ```
1. Add to crontab
    ```cron
    0 1 * * * /root/tailscale-ssl.sh
    ```
1. Check Proxmox URL (example)
   `https://compy386.tail1e02a.ts.net:8006`

# Enable Automatic Updates

1. Install unattended upgrades
    ```bash
    apt update
    apt install unattended-upgrades
    dpkg-reconfigure --priority=low unattended-upgrades
    ```
2. Edit auto-clean interval

    ```bash
    nano /etc/apt/apt.conf.d/20auto-upgrades
    ```

    Add:

    ```conf
    APT::Periodic::AutocleanInterval "21";
    ```

# Synology NAS (optional)

1. Navigate to `Datacenter > Storage`
2. Add SMB/CIFS with the following
    - **Server:** `ip.address`
    - **Share:** `home` (or other shared folder)
    - **Content:** `VZDump backup file`

# Troubleshooting

Getting stuck on "waiting for /dev to be a fully populated" during installation?

1. Restart the node
1. From the installation menu, press the `e` key
1. At the end of the `linux` boot line, add a space and the following word: `nomodeset`
1. Press `Ctrl + X` to boot with this option

This should allow the installation to proceed without issues.

---

-   **Previous step:** [Set variables](./variables.md) like your server name, first username, and application secrets
-   **Next step:** [Create a Linux VM](./linux-vm.md) in Proxmox and configure it for Ansible
