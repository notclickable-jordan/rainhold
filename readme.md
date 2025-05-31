# Ansible

## Putting SSH key in authorized_keys

Run:

```bash
ssh-copy-id jordan@192.168.1.57
```

## Encrypting variables

Run:

```bash
ansible-vault encrypt ansible/inventory/host_vars/beacon.yml
```

## Running playbooks

Run the playbook with:

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user jordan
```