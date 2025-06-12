# Grafana

Grafana supports generic OAuth providers, such as Pocket ID.

-   Callback URL: https://grafana.example.com/login/generic_oauth
-   Scopes: `openid email profile groups` (do not use `user:email`)
-   [x] Allow sign up

## User mapping

-   Name attribute path: `name`
-   Login attribute path: `email`
-   Email attribute name: `email`
-   Organization mapping:
    -   `grafana_editor:1:Editor`
-   Organization attribute path: `groups`
