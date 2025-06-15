# Mastodon setup

## Postgres

1. Create mastodon role
    ```bash
    docker run --rm --name postgres \
    -v mastodon_db:/var/lib/postgresql/data \
    -e POSTGRES_USER=mastodon \
    -e POSTGRES_PASSWORD="<password>" \
    -d postgres:14-alpine
    ```
1. Can sign in with
    ```bash
    docker exec -it postgres psql -U mastodon
    ``` 

## Put this in .env.production

```
DB_HOST=db
DB_PORT=5432
DB_NAME=mastodon
DB_USER=mastodon
DB_PASS=<password>
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=
```

## Started Mastodon setup

```bash
docker compose run --rm web bundle exec rake mastodon:setup
```

## Saved output to .env.production

Copy what's in the terminal and paste it into .env.production

## Fixed 502 bad gateway in nginx config

```conf
upstream backend {
    server localhost:3000 fail_timeout=0;
}
```

## Restored postgres database

1. Copied database backup to container
    ```bash
    docker cp '/Users/me/Desktop/Backup/backup.dump' postgres:/
    ```
1. Terminal to postgres container in Docker
    ``` bash
    pg_restore -Fc -U mastodon -n public --no-owner --role=mastodon -d mastodon -c backup.dump
    ```

## Recompiled mastodon

1. Went into the web container terminal and ran
    ```bash
    RAILS_ENV=production bundle exec rails assets:precompile
    RAILS_ENV=production ./bin/tootctl feeds build
    ```