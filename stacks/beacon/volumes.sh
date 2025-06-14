# List of volumes and their mount points (must match across scripts)
# Format: VOLUME_NAME:MOUNT_PATH
VOLUMES=(
  "caddy_config:/caddy/config"
  "caddy_data:/caddy/data"
  "freshrss_data:/freshrss/data"
  "freshrss_extensions:/freshrss/extensions"
  #"gitea_data:/gitea/data"
  #"gitea_db:/gitea/db"
  "grafana_storage:/grafana/storage"
  "lemmy_extra_themes:/lemmy/extra-themes"
  "lemmy_pictrs:/lemmy/pictrs"
  "lemmy_postgres:/lemmy/postgres"
  "lldap_lldap_data:/lldap/data"
  "n8n_app:/n8n/app"
  "n8n_db:/n8n/db"
  "pocket-id_data:/pocket-id/data"
)

BACKUP_PATH="/mnt/backup/rainhold/beacon"
