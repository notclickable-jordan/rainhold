# Ansible

Ansible is used to automate the deployment and configuration of your server environment.

# Mac setup

## Install Homebrew

Run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Python 3

Run:

```bash
brew install python
pip3 install --user 'passlib[bcrypt]'
```

## Install Ansible

Run:

```bash
pip3.9 install ansible
```

# Encrypting variables

```bash
ansible-vault encrypt ansible/inventory/host_vars/beacon.yml
```

# Running the playbook

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass --user strongbad --inventory ansible/inventory/hosts.yml
```
