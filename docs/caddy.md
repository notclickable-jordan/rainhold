# Caddy

Why does Caddy use a personal Docker image? Because, in order to get SSL certificates through Cloudflare, I needed to use a custom build of Caddy. You should not use this you're not using Cloudflare.

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
