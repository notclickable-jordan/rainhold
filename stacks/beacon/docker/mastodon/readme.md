# Mastodon

The stack's `.env` and `.env.postgres` are rendered by Ansible from `ansible/roles/docker-env/templates/mastodon.env*.j2` using the `mastodon_*` variables in your host vars. Don't edit them on the server; change the host vars and re-run the playbook.

## First-time setup

Generate the secrets for your host vars (`mastodon_secret_key_base`, `mastodon_otp_secret`, the VAPID keys and the Active Record encryption keys):

```bash
docker compose run --rm web bundle exec rails secret
docker compose run --rm web bundle exec rails mastodon:webpush:generate_vapid_key
docker compose run --rm web bundle exec rails db:encryption:init
```

Then create the database schema:

```bash
docker compose run --rm web bundle exec rails db:setup
```

## Restoring a Postgres dump

1. Copy the dump into the database container
    ```bash
    docker cp backup.dump mastodon_db:/
    ```
1. Restore it
    ```bash
    docker exec -it mastodon_db pg_restore -Fc -U mastodon -n public --no-owner --role=mastodon -d mastodon -c /backup.dump
    ```
1. Rebuild home feeds
    ```bash
    docker exec mastodon_web bin/tootctl feeds build
    ```

## Updating

Bump the image tags in `compose.yml`, commit, and re-run the playbook. Check the release notes for required migrations, which you can run with:

```bash
docker compose run --rm web bundle exec rails db:migrate
```

The `mastodon-feeds` Ansible role rebuilds home feeds every 30 minutes.
