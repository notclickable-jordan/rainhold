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
