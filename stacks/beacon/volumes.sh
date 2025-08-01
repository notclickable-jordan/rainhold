# List of volumes and their mount points (must match across scripts)
# Format: VOLUME_NAME:MOUNT_PATH
VOLUMES=(
  "audiobookshelf_config:/audiobookshelf/config"
  "audiobookshelf_metadata:/audiobookshelf/metadata"
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
  "mastodon_sidekiq:/mastodon/sidekiq"
  "mastodon_web:/mastodon/web"
  "n8n_app:/n8n/app"
  "n8n_db:/n8n/db"
  "pocket-id_data:/pocket-id/data"
  "vaultwarden_data:/vaultwarden/data"
  "ytptube_config:/ytptube/config"
)

BACKUP_PATH="/mnt/backup/rainhold/beacon"
