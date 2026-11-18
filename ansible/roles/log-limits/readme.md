# log-limits role

Bounds log growth so a logging flood cannot fill the root filesystem.

## Why this exists

A kernel/syslog flood produced two 195G files (`/var/log/syslog.1` and
`/var/log/kern.log.1`) and filled `/` to 100%. The visible symptom was the Gitea
Actions runner hanging on the checkout step and timing out after ~15 minutes,
with nothing useful in the container logs.

`logrotate` had rotated both files but only runs daily by default, so a fast
flood grows unbounded between runs. This role adds `maxsize` caps and an hourly
timer so rotation triggers on size rather than only on schedule.

## What it does

- Caps the systemd journal via a `journald.conf.d` drop-in
- Replaces the stock `/etc/logrotate.d/rsyslog` (backed up to
  `/etc/logrotate.d.disabled/`) with size-capped rules for every file it
  rotated (`logrotate_managed_logs`)
- Runs `logrotate.timer` hourly so `maxsize` is enforced promptly
- Caps Docker `json-file` container logs
- Installs an hourly disk usage check that warns above a threshold

## Usage

```yaml
- hosts: public
  roles:
      - log-limits
```

Runs in `initial-setup.yml` before `docker-install`, so `/etc/docker/daemon.json`
is in place before any container is created.

## Variables

| Variable                       | Default | Purpose                                    |
| ------------------------------ | ------- | ------------------------------------------ |
| `journald_system_max_use`      | `500M`  | Total journal size cap                     |
| `journald_system_max_file_size`| `50M`   | Per-file journal cap                       |
| `logrotate_managed_logs`       | 11 paths | Files given size-capped rotation          |
| `logrotate_max_size`           | `500M`  | Rotate once a file exceeds this            |
| `logrotate_rotate_count`       | `7`     | Rotations retained                         |
| `logrotate_hourly`             | `true`  | Run logrotate hourly instead of daily      |
| `docker_log_max_size`          | `10m`   | Per-container log file cap                 |
| `docker_log_max_file`          | `3`     | Container log files retained               |
| `disk_warn_threshold_percent`  | `80`    | Warn above this usage; `0` disables        |

## Caveats

- The Docker log cap applies to **newly created** containers. Recreate existing
  stacks (`docker compose up -d --force-recreate`) to pick it up.
- The disk warning goes to syslog via `logger`, and to ntfy when the
  `ntfy-notifications` helper is installed.
- This role bounds damage; it does not stop a flood at the source.
