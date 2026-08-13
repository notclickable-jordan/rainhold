# nftables-logging role

# Ensures nftables logs are visible in Grafana via Loki/Promtail

This role:

-   Enables logging on the nftables **input** and **output** chains
-   Configures Promtail to collect nftables logs
-   Reloads nftables and Promtail as needed

## The forward chain is deliberately not logged

Logging the `forward` chain on a Docker host logs every packet of every
container, since all container traffic is forwarded. Combined with tasks that
appended a duplicate log rule on every playbook run, this wrote roughly 195G/day
into `/var/log/kern.log` and `/var/log/syslog`, filled the root filesystem, and
hung the Gitea Actions runner on its checkout step.

The role now removes any `forward` chain log rules it finds, and converges the
`input` and `output` chains on exactly one log rule each rather than appending.
Re-running the playbook is safe and reports no changes at steady state.

If you need forward-chain visibility, add a rate limit rather than logging every
packet, for example `limit rate 10/minute` on the rule.

See also the `log-limits` role, which caps log file growth so a future flood
cannot fill the disk.

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
