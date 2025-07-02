# GitLab

GitLab will send the `external_url` to the runner container. If you put a authentication layer in front of the runner, it will not be able to access the GitLab instance.

## Root login

After creating the container, the root login won't work. Go into the container manually to set the password.

1. `docker exec -it gitlab /bin/bash`
2. Run `gitlab-rake "gitlab:password:reset"`
3. Enter a user name, in this case 'root' (no quotes) and password

# Runner

To launch a short-lived gitlab-runner container to register the container you created during installation:

1. Get the registration token from the GitLab UI
1. Run:
    ```bash
    sudo docker run --rm -it \
    --network caddy \
    -v gitlab_runner:/etc/gitlab-runner \
    gitlab/gitlab-runner:latest register \
    --url "http://gitlab" \
    --token "RUNNER_TOKEN_HERE" \
    --description "Default" \
    --executor "docker" \
    --docker-image ruby:3.3
    ```
1. Keep pressing `ENTER` to accept the defaults

# Runner clone failure

Got an error from a pipeline job while trying to clone the repository. To solve this, I had to edit the runner container's config.toml and add a clone URL and network.

1. Run:
    ```bash
    docker exec -it gitlab-runner /bin/bash
    apt-get update
    apt-get install -y nano
    nano /etc/gitlab-runner/config.toml
    ```
1. Add this clone_url below url
    ```
    clone_url = "http://gitlab"
    ```
1. Add this network at the bottom of `[runners.docker]`
    ```
    network_mode = "caddy"
    ```
1. Save the file and exit (`Ctrl-X`, then `Y`, then `Enter`)
1. Exit the container
    ```bash
    exit
    ```
1. Restart the container
    ```
    docker restart gitlab-runner
    ```
