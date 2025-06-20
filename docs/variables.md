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

# Generate secrets

Most secrets can be generated using the `openssl` command below:

```bash
openssl rand -base64 32
```

## username

Your first username, e.g. `strongbad`

### linux_first_user_ssh_public_key

Your SSH public key, e.g. `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC...`

1. Follow [GitHub's guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) to generate a new SSH key
2. Then [copy the public key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and paste it here

### tailscale_authkey

Your Tailscale auth key, e.g. `tskey-1234567890abcdef`

1. Follow [Tailscale's guide](https://tailscale.com/kb/1085/auth-keys) to generate a new auth key

### cloudflared_token

Your Cloudflare token, e.g. `1234567890abcdef1234567890abcdef`

1. Follow [Cloudflare's guide](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/) to generate a new token

### cloudflare_ssl_api_token

Your Cloudflare SSL API token, e.g. `1234567890abcdef1234567890abcdef`

1. Follow [Cloudflare Tunnels](./cloudflare.md#ssl-api-key) for details on how to set this up

### tinyauth_secret

1. Generate with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32`
2. Trim the string so it is exactly `32` characters long

### tinyauth_pocket_id_client_id and tinyauth_pocket_id_client_secret

1. Follow [Tinyauth's guide](https://tinyauth.app/docs/guides/pocket-id.html) to create a new client

### apprise_mastodon_token

Your Mastodon token, e.g. `1234567890abcdef1234567890abcdef`

1. Sign in to your Mastodon account, go to **Settings &gt; Development &gt; New Application**, and create a new application with the following settings:
    1. **Name**: `Apprise`
    1. **Scopes**:
        - `write:statuses`
        - `write:media`
        - `read:accounts`

### `gitea_runner_registration_token`

1. Generate in Gitea after installing it
1. Go to **Site Administration &gt; Actions &gt; Runners** and click **Create new Runner**
1. Copy the registration token and paste it here
1. Re-run the Ansible playbook to register the runner
