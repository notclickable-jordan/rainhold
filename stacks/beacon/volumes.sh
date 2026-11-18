# List of volumes and their mount points (must match across scripts)
# Format: VOLUME_NAME:MOUNT_PATH
VOLUMES=(
  "caddy_config:/caddy/config"
  "caddy_data:/caddy/data"
  "docent_data:/docent/data"
  "dozzle_dozzle_data:/dozzle/data"
  "freshrss_data:/freshrss/data"
  "freshrss_extensions:/freshrss/extensions"
  "gitea_data:/gitea/data"
  "gitea_db:/gitea/db"
  "gitea_runner_data:/gitea/runner-data"
  "jellyfin_cache:/jellyfin/cache"
  "jellyfin_config:/jellyfin/config"
  "lemmy_extra_themes:/lemmy/extra-themes"
  "lemmy_pictrs:/lemmy/pictrs"
  "lemmy_postgres:/lemmy/postgres"
  "lldap_lldap_data:/lldap/data"
  "mastodon_db:/mastodon/db"
  "mastodon_web:/mastodon/web"
  "ntfy_cache:/ntfy/cache"
  "ntfy_data:/ntfy/data"
  "pocket-id_data:/pocket-id/data"
  "podcastdn_db:/podcastdn/db"
)

# Stacks running Postgres. These are stopped while their volumes are archived
# so the database files on disk are consistent.
BACKUP_PATH="/mnt/backup/rainhold/beacon"
