# Caddy

Caddy uses a personal Docker image to get SSL certificates through Cloudflare. There was no existing Docker image that did this, so I made one. You should not use this Caddy image you're not using Cloudflare.

## My Caddy image

```yaml
image: jordanroher/caddy-cloudflare-dns
```

-   [GitHub repository](https://github.com/notclickable-jordan/caddy-cloudflare-dns)
-   [Docker Hub repository](https://hub.docker.com/r/jordanroher/caddy-cloudflare-dns)

## Normal Caddy image

```yaml
image: caddy:alpine
```
