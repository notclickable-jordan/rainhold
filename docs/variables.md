# Clone this repository

```bash
git clone https://github.com/notclickable-jordan/rainhold.git
```

# Server and user

Come up with a name for your hypervisor (Proxmox), Linux virtual machine, and your first username on the Linux VM. These are mine:

-   Hypervisor: `rainhold`
-   Linux VM: `beacon`
-   First username: `jordan`

For the sake of replacement, let's pretend these are yours:

-   Hypervisor: `strongserver`
-   Linux VM: `compy386`
-   First username: `strongbad`

# Ansible

1. Open `ansible/inventory/hosts.yml`
1. Change both instances of `beacon` to your Linux VM name
1. You won't have `ansible_host` yet; come back to that after creating the VM in Proxmox

# Host variables

1. Make a copy of `host_vars/sample.yml` and give it the name of your Linux VM, e.g. `compy386.yml`
1. This will cause your text editor (and git) to ignore the file
    - That's normal
    - It protects you from accidentally committing your secret keys
1. Open `compy386.yml` and follow the comments

## Generating secrets

Generate alphanumeric secrets using OpenSSL:

```bash
openssl rand -base64 32
```

---

-   **Next step:** [Create a Proxmox hypervisor](./proxmox.md) and configure it for Tailscale and SSL
