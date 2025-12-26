# List of volumes and their mount points (must match across scripts)
# Format: VOLUME_NAME:MOUNT_PATH
VOLUMES=(
  "caddy_config:/caddy/config"
  "caddy_data:/caddy/data"
  "calibre_config:/calibre/config"
  "miniflux_db:/miniflux/db"
  "gitea_data:/gitea/data"
  "gitea_db:/gitea/db"
  "grafana_storage:/grafana/storage"
  "jellyfin_cache:/jellyfin/cache"
  "jellyfin_config:/jellyfin/config"
  "lemmy_extra_themes:/lemmy/extra-themes"
  "lemmy_pictrs:/lemmy/pictrs"
  "lemmy_postgres:/lemmy/postgres"
  "lldap_lldap_data:/lldap/data"
  "mastodon_db:/mastodon/db"
  "mastodon_redis:/mastodon/redis"
  "mastodon_web:/mastodon/web"
  "pocket-id_data:/pocket-id/data"
)

BACKUP_PATH="/mnt/backup/rainhold/beacon"
