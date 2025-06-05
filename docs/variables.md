# Variables

To begin, come up with a name for your server, and your first username. These are mine:

-   Server name: `beacon`
-   First username: `jordan`

For the sake of replacement, let's pretend these are yours:

-   Server name: `compy386`
-   First username: `strongbad`

## Ansible

1. Open `ansible/inventory/hosts.yml`
1. Change both instances of `beacon` to your server name
1. You won't have `ansible_host` yet; come back to that after creating the VM in Proxmox

## Host variables

1. Rename `host_vars/sample.yml` to the name of your server, e.g. `compy386.yml`
1. This will cause your text editor (and git) to ignore the file. That's normal. It protects you from accidentally committing your secret keys.
1. Open `comp386.yml` and follow the guide in comments (lines starting with `#`):
    - `keep` &gt; don't change it
    - `replace` &gt; replace with your own secret (create however you like)
    - `generate` &gt; follow the instructions below to generate a new secret

## Generate secrets

### username

Your first username, e.g. `strongbad`

### user_ssh_pubkey

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

### LLDAP_JWT_SECRET and LLDAP_KEY_SEED

1. Generate a random string, e.g. `openssl rand -base64 32`

### tinyauth_secret

1. Generate with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32`
2. Trim the string so it is exactly `32` characters long

### tinyauth_pocket_id_client_id and tinyauth_pocket_id_client_secret

1. Follow [Tinyauth's guide](https://tinyauth.app/docs/guides/pocket-id.html) to create a new client

### apprise_mastodon_token

Your Mastodon token, e.g. `1234567890abcdef1234567890abcdef`

1. Sign in to your Mastodon account, go to **Settings &gt; Development &gt; New Application**, and create a new application with the following settings:
    1. **Name**: `Apprise`
    2. **Scopes**:
        - `write:statuses`
        - `write:media`
        - `read:accounts`

### `GITEA__database__PASSWD`

1. Generate a random string, e.g. `openssl rand -base64 32`

### `gitea_runner_registration_token`

1. Generate in Gitea after installing it
2. Go to **Site Administration &gt; Actions &gt; Runners** and click **Create new Runner**
3. Copy the registration token and paste it here
