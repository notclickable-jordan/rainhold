# Ports and services

| Port    | Service       | Description                 |
| ------- | ------------- | --------------------------- |
| 25      | Postfix       | SMTP server for email       |
| 80, 443 | Caddy         | Web server for HTTP traffic |
| 143     | Dovecot       | IMAP email server           |
| 389     | LLDAP         | LDAP service                |
| 4209    | Gitea SSH     | Gitea SSH access            |
| 4214    | Loki          | Log aggregation             |
| 4215    | Prometheus    | Metrics collection          |
| 4216    | Lemmy pgAdmin | Lemmy database management   |
| 4217    | GitLab SSH    | GitLab SSH access           |
