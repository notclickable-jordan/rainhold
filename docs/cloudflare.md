# Cloudflare Tunnels

## Zero Trust public hostnames

Public hostnames should be configured as:

-   Hostname: subdomain.domain.com
-   Service: HTTPS://localhost:443
-   TLS > Origin server name: subdomain.domain.com
-   No TLS verify (checked)
