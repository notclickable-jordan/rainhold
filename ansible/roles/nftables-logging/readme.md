# nftables-logging role

# Ensures nftables logs are visible in Grafana via Loki/Promtail

This role:

-   Enables logging in nftables rules
-   Configures Promtail to collect nftables logs
-   Reloads nftables and Promtail as needed

## Usage

Add `nftables-logging` to your playbook roles:

```yaml
- hosts: all
  roles:
      - nftables-logging
```

## Variables

-   `nftables_log_prefix`: Prefix for nftables log lines (default: "nftables-")
-   `nftables_log_file`: Log file to collect (default: "/var/log/syslog")
