# Pocket ID and LLDAP

Connect Pocket ID to your LLDAP server to manage users and groups. This lets Pocket ID handle authentication while letting LLDAP be the source for user management.

## Prerequisites

Set up your LLDAP server. This will happen during the Ansible deployment process.

## Admin user

To access the Pocket ID admin interface after installing it for the first time, visit `https://pocketid.example.com/login/setup`

# LDAP

In Pocket ID, go to **Application Configuration &gt; LDAP** and enter the following details:

## Client Configuration

| Field                             | Value                                        |
| --------------------------------- | -------------------------------------------- |
| **LDAP URL**                      | `ldap://tailscale.ip.address:4201`           |
| **LDAP Bind DN**                  | `uid=admin,ou=people,dc=notclickable,dc=com` |
| **LDAP Bind Password**            | _(set via UI — use value from `.env`)_       |
| **LDAP Base DN**                  | `dc=notclickable,dc=com`                     |
| **User Search Filter**            | `(objectClass=person)`                       |
| **Groups Search Filter**          | `(objectClass=groupOfNames)`                 |
| **Skip Certificate Verification** | (enabled)                                    |
| **Keep Disabled Users**           | (enabled)                                    |

---

## Attribute Mapping

| Attribute                             | Value               |
| ------------------------------------- | ------------------- |
| **User Unique Identifier Attribute**  | `uuid`              |
| **Username Attribute**                | `user_id`           |
| **User Mail Attribute**               | `mail`              |
| **User First Name Attribute**         | `first_name`        |
| **User Last Name Attribute**          | `last_name`         |
| **User Profile Picture Attribute**    | `avatar`            |
| **Group Members Attribute**           | `member`            |
| **Group Name Attribute**              | `display_name`      |
| **Group Unique Identifier Attribute** | `uuid`              |
| **Admin Group Name**                  | `_admin_group_name` |

# Jellyfin

Follow this guide to [set up Jellyfin with Pocket ID](https://pocket-id.org/docs/client-examples/jellyfin).

The short version:

-   Install the [Jellyfin SSO plugin](https://github.com/9p4/jellyfin-plugin-sso?tab=readme-ov-file)
-   The OID endpoint should just be the domain, without a trailing slash, e.g. `https://pocketid.example.com`
-   In "Scheme override", enter `https`
