# Private sites using Tailscale and NextDNS

Create private sites that are accessible only while your device is connected to Tailscale and NextDNS. This setup allows you to have secure access to your private services without exposing them to the public internet.

## Cloudflare

In Cloudflare, create a new DNS record for your private site, e.g., `private.example.com`

-   **Type:** A
-   **Name:** private
-   **IPv4 address:** 127.0.0.1
-   **Proxy status:** DNS only (grey cloud)

## NextDNS

In NextDNS, go to Settings > Rewrites and add a new rewrite:

-   **Domain:** private.example.com
-   **Answer:** (Tailscale IP address of server)

## Caddy

Keep the site configuration in `Caddyfile` as is, e.g.

```caddyfile
private.example.com {
    tls {
        dns cloudflare {{ cloudflare_ssl_api_token }}
    }

    reverse_proxy http://service:port
}
```

---

-   **Previous step:** [Set up Cloudflare](./cloudflare.md) tunnels and DNS for public sites
