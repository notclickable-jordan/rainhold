# Pocket ID and LLDAP

In Pocket ID, you can connect to your LLDAP server to manage users and groups. This allows you to use Pocket ID for authentication while leveraging LLDAP for user management.

## Prerequisites

Set up your LLDAP server. This will happen during the Ansible deployment process.

## Admin user

To access the Pocket ID admin interface after installing it for the first time, visit `https://pocketid.example.com/login/setup`

# LDAP

In Pocket ID, go to **Application Configuration &gt; LDAP** and enter the following details:

## Client Configuration

| Field                             | Value                                        |
| --------------------------------- | -------------------------------------------- |
| **LDAP URL**                      | `ldap://100.89.146.30:4201`                  |
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
