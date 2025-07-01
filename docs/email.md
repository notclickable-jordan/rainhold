# Email

The Ansible role `postfix` sets up a local email server using Postfix and Dovecot. It receives email on port 25 sent to any address and delivers to the user account specified in `dovecot_mail_user` in `sample.yml`.

## SMTP

SMTP on your Docker services should be sent to `{{ ansible_hostname }}` on port 25. No authentication is required.

## Mail client

Any mail client can be used to connect to the email server.

-   **Type**: IMAP
-   **Server**: (Tailscale hostname or IP address, e.g. mine is `rainhold-beacon`)
-   **Port**: 143
-   **Username**: `mailuser`
-   **Password**: `dovecot_mail_user_password_raw` in `sample.yml`
