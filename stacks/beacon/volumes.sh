# List of volumes and their mount points (must match across scripts)
# Format: VOLUME_NAME:MOUNT_PATH
VOLUMES=(
  "caddy_config:/caddy/config"
  "caddy_data:/caddy/data"
  "calibre_config:/calibre/config"
  "freshrss_data:/freshrss/data"
  "freshrss_extensions:/freshrss/extensions"
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
  "podcastdn_db:/podcastdn/db"
  "podcastdn_tmp:/podcastdn/tmp"
)

BACKUP_PATH="/mnt/backup/rainhold/beacon"
