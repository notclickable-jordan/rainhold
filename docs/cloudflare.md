# Cloudflare Tunnels

## Zero Trust public hostnames

Public hostnames should be configured as:

-   Hostname: subdomain.example.com
-   Service: HTTPS://localhost:443
-   TLS > Origin server name: subdomain.example.com
-   No TLS verify (checked)

## SSL API key

To get SSL certificates through Cloudflare, you need to set up an API key. This is done in the Cloudflare dashboard:

1. Click the profile icon in the top right corner
2. Go to **Profile**
3. Click **API Tokens**
4. Click **Create Token**
5. Select **Create custom token**
6. Name the token (e.g., "SSL API Key")
7. Under **Permissions**, add two:
    - **Zone > Zone > Read**
    - **Zone > DNS > Edit**
8. Click **Continue to summary**
9. Review the permissions and click **Create Token**
10. Copy the token and save it in your `host_vars/<hostname>.yml` file as `cloudflare_ssl_api_token`

---

-   **Previous step:** [Use Ansible](./ansible.md) to configure the Linux VM and its Docker containers
-   **Next step:** [Shield private sites](./private.md) with Tailscale and NextDNS
