# Deploying the `secure` changes

Manual steps for deploying the security hardening branch to beacon, in order.

## Before running the playbook

**1. Accept the SSH host key.** Ansible now refuses hosts it doesn't recognize. From your Mac:

```bash
ssh strongbad@100.127.35.9
```

Check the fingerprint, answer `yes`, then exit.

**2. Edit `ansible/inventory/host_vars/beacon.yml`.**

- **Root password hash:** give it a fixed salt. Before, the salt was random, so the hash (and the root password task) changed on every run. The salt can be up to 16 characters from `a-zA-Z0-9./`:
    ```yaml
    linux_root_password_new: "{{ 'yourpassword' | password_hash('sha512', 'pickAsalt123') }}"
    ```
- **PodCastDN:** delete `podcastdn_DATABASE_URL`. The connection string is now built from the `podcastdn_POSTGRES_*` variables.
- **Lemmy:** Lemmy now reads `lemmy_postgres_password` instead of `lemmy_db_password`.
    - If the two values were the same, delete `lemmy_db_password` and you're done.
    - If they were different, Lemmy was logging in with `lemmy_db_password`. Copy that value into `lemmy_postgres_password`, then delete `lemmy_db_password`.
- **ntfy:** add these variables. Run the commands on the server, where Docker is available.
    ```bash
    docker run --rm -it binwiederhier/ntfy user hash      # prompts for a password and prints a $2a$… hash
    docker run --rm binwiederhier/ntfy token generate     # prints tk_…
    ```
    ```yaml
    ntfy_admin_user: "admin"
    ntfy_admin_password_hash: "$2a$10$…"    # keep it quoted
    ntfy_admin_token: "tk_…"
    ntfy_anonymous_write_topics: []         # list topics here only for senders that can't log in
    ```

**3. Set the Mastodon database password.** Until now that database let any container in without a password, so the stored password may never have matched `mastodon_postgres_password`. After this change Mastodon has to log in with a password, so set it now while the old access still works:

```bash
docker exec -it mastodon_db psql -U mastodon -d mastodon
```

At the `psql` prompt, run the following and enter the exact `mastodon_postgres_password` value:

```
\password mastodon
\q
```

Using `\password` keeps the password out of your shell history.

## Deploy

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user strongbad --inventory ansible/inventory/hosts.yml
```

Every stack is recreated during the run, Caddy included, so the new Caddy settings take effect without a manual restart.

## After the deploy

**4. Pocket ID.** Go to **Application Configuration › LDAP** and set the LDAP URL to `ldap://lldap:3890`. Port 389 is no longer published on the host, and Pocket ID now reaches LLDAP directly over the Docker network.

**5. ntfy clients.** Anonymous access is now denied, so every client needs credentials:

- **Phone app:** Settings › Manage users › add your ntfy server URL with the admin username and password. Your subscriptions should then work again.
- **Web UI:** log in with the same account.
- **Other publishers** (scripts, apps): use the token as `Authorization: Bearer tk_…`, or add their topic to `ntfy_anonymous_write_topics`.

**6. Smoke test.**

- **Sites:** log in to each public site.
- **Gitea:** run a CI job to confirm the runner still works on its new network.
- **Mastodon:** check that `docker logs mastodon_web` shows no authentication errors.

**7. Backups.** Nothing to change. Starting tonight, every stack is stopped in turn while its volumes are archived around 1 AM, so each service goes down briefly (about 2 minutes total). Only services that were running beforehand are started again. To test it now, run `backup.sh` from the beacon stack directory on the server.

## Going forward

- **Caddyfile edits outside the playbook:** run `docker restart caddy`. With the admin API off, `caddy reload` no longer works.
- **Image updates:** replace both the tag and the `@sha256:` digest in `compose.yml`. A plain `docker compose pull` won't move to a newer version anymore.
