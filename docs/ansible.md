# Ansible

Ansible is used to automate the deployment and configuration of your server environment.

## Mac setup

1. Install [Homebrew](https://brew.sh/)
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
1. Install Python 3
    ```bash
    brew install python
    pip3 install --user 'passlib[bcrypt]'
    ```
1. Install Ansible
    ```bash
    pip3.9 install ansible
    ```

# Running the playbook

This will configure your Debian VM with all the necessary services and settings. The playbook will prompt you for your user's (e.g. `strongbad`) password.

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user strongbad --inventory ansible/inventory/hosts.yml
```

This will take a long time to run. Once it's done, use [Cloudflare](./cloudflare.md) to set up your public sites and Tailscale/NextDNS for [private sites](./private.md).

## Troubleshooting

If the Tailscale Ansible role fails, disable manual device approval in the Tailscale admin console.

---

-   **Previous step:** [Create a Linux VM](./linux-vm.md) in Proxmox and configure it for Ansible
-   **Next step:** [Set up Cloudflare](./cloudflare.md) tunnels and DNS for public sites
