# Email with Mailrise and Apprise

## Mailrise

[Project homepage](https://github.com/YoRyan/mailrise)

This is a private server, so Cloudflare, Tailscale, and NextDNS are involved.

Follow the instructions in [private site](private.md) to set up a DNS record in Cloudflare, a rewrite in NextDNS, and a reverse proxy in Traefik.

## Mastodon

1. Go to My Profile > Development
1. Create a new application
1. Give it these scopes:
    - `write:statuses`
    - `write:media`
    - `read:accounts` (optional, only if you want to send a DM to yourself)
1. Copy the `Client ID` and `Client Secret` from the application page
