# Ansible

## Encrypting variables

Run:

```bash
ansible-vault encrypt ansible/inventory/host_vars/light.yml
```

## Running playbooks

Run the playbook with:

```bash
ansible-playbook ansible/playbook.yml --ask-vault-pass
```