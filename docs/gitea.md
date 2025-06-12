# Gitea

## Runner

You won't have the host variable `gitea_runner_registration_token` until you create the Gitea instance. Run the playbook to create the Gitea instance, get the token and set it in your version of `sample.yml`. Then re-run the Ansible playbook.

## Authentication source

Gitea can authenticate with Pocket ID.

To enable users with certain groups to have access to an organization and team, try these steps. I'm not sure they work.

1. In LLDAP, create a group (e.g. `gitea`)
1. Add users to the group
1. Create a new organization in Gitea (e.g. `Main`)
1. Create a new team in the organization (e.g. `Developers`)
1. In the Pocket ID authentication source:
    - Additional scopes: `groups`
    - Claim name providing group names for this source: `groups`
    - Map claimed groups to Organization teams
        ```json
        { "gitea": { "Main": ["Developers"] } }
        ```
