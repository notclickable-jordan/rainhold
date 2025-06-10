# List of volumes and their mount points (must match across scripts)
# Format: VOLUME_NAME:MOUNT_PATH
VOLUMES=(
  "gitea_data:/gitea/data"
  "gitea_db:/gitea/db"
  "n8n_app:/n8n/app"
  "n8n_db:/n8n/db"
  "lldap_lldap_data:/lldap/data"
  "caddy_data:/caddy/data"
  "caddy_config:/caddy/config"
  "pocket-id_data:/pocket-id/data"
  "lemmy_extra_themes:/lemmy/extra-themes"
  "lemmy_pictrs:/lemmy/pictrs"
  "lemmy_postgres:/lemmy/postgres"
  "freshrss_data:/freshrss/data"
  "freshrss_extensions:/freshrss/extensions"
)
