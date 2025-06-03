# Pocket ID and LLDAP

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
