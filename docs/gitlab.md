# GitLab

After creating the container, the root login won't work. Go into the container manually to set the password.

1. `docker exec -it gitlab /bin/bash`
2. Run `gitlab-rake "gitlab:password:reset"`
3. Enter a user name, in this case 'root' (no quotes) and password

# Runner

To launch a short-lived gitlab-runner container to register the container you created during installation:

1. Run:
    ```bash
    sudo docker run --rm -it \
    --network caddy \
    -v gitlab-runner:/etc/gitlab-runner \
    gitlab/gitlab-runner:latest register
    ```
2. GitLab instance URL: `http://gitlab`
3. Enter registration token and name ("runner" is fine)
4. Executor: `docker`
5. Default image: `node:22`

# Runner clone failure

Got an error from a pipeline job while trying to clone the repository. To solve this, I had to edit the runner container's config.toml.

1. `docker exec -it gitlab-runner /bin/bash`
2. `apt-get update`
3. `apt-get install nano`
4. `cd /etc/gitlab-runner`
5. `nano config.toml`
6. Add this clone_url below url
    ```
    clone_url = "http://gitlab"
    ```
7. Restart the container
    ```
    docker restart gitlab_runner
    ```
