# Server and user

Come up with a name for your server, and your first username. These are mine:

-   Server name: `beacon`
-   First username: `jordan`

For the sake of replacement, let's pretend these are yours:

-   Server name: `compy386`
-   First username: `strongbad`

# Ansible

1. Open `ansible/inventory/hosts.yml`
1. Change both instances of `beacon` to your server name
1. You won't have `ansible_host` yet; come back to that after creating the VM in Proxmox

# Host variables

1. Make a copy of `host_vars/sample.yml` and give it the name of your server, e.g. `compy386.yml`
1. This will cause your text editor (and git) to ignore the file
    - That's normal
    - It protects you from accidentally committing your secret keys
1. Open `compy386.yml` and follow the comments

Generate alphanumeric secrets using OpenSSL:

```bash
openssl rand -base64 32
```
