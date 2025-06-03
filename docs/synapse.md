# Synapse: Generating a configuration file

Generate a valid config file with the following command on the remote server.

Adjust the `SYNAPSE_SERVER_NAME` to your domain name.

```bash
docker run -it --rm \
    --mount type=volume,src=synapse_files,dst=/data \
    -e SYNAPSE_SERVER_NAME=synapse.notclickable.com \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest generate
```

# Generating a user

After synapse is running, you may wish to create a user via `register_new_matrix_user`.

Run:

```
docker exec -it synapse register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml --help
```

Remember to remove the `registration_shared_secret` and restart if you no-longer need it.

# LDAP support

Synapse supports LDAP authentication.

First, install `nano` on the server:

```bash
docker exec -it synapse
apt update && apt install -y nano
```

To enable LDAP, you need to add the following configuration to your `data/homeserver.yaml` file:

```yaml
modules:
    - module: "ldap_auth_provider.LdapAuthProviderModule"
      config:
          enabled: true
          uri: "ldap://ip.address:389"
          start_tls: true
          base: "ou=people,dc=example,dc=com"
          attributes:
              uid: "admin"
              mail: "mail"
              name: "user_id"
```

Save and restart the server.
