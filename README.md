# Homelab

Public infrastructure and configuration-management code for my homelab. The
repository is being published in phases so each component can be reviewed and
documented before it becomes public.

## Currently published: Uptime Kuma

This first phase contains two independent pieces:

| Path | Purpose |
| --- | --- |
| [`configuration-management/uptime-kuma`](configuration-management/uptime-kuma) | Ansible playbook that installs Uptime Kuma on an ARMv6 Raspberry Pi. |
| [`iac/homelab/uptime-kuma`](iac/homelab/uptime-kuma) | Terraform root that configures monitors in a running Uptime Kuma instance. |
| [`iac/modules/uptime-kuma`](iac/modules/uptime-kuma) | Reusable Terraform implementation used by the homelab root. |

## Install Uptime Kuma with Ansible

The playbook targets Debian/Raspbian on ARMv6. Update `inventory.ini` for the
target host, verify SSH access, and run:

```bash
cd configuration-management/uptime-kuma
ansible all -i inventory.ini -m ping
ansible-playbook -i inventory.ini playbook.yml --syntax-check
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

The playbook installs a pinned unofficial Node.js ARMv6 build, compiles the
SQLite dependency, and creates a systemd service listening on port 80. See the
[component README](configuration-management/uptime-kuma/README.md) for details.

## Manage monitors with Terraform

The Terraform configuration requires Terraform 1.16.4 and a reachable Uptime
Kuma instance. Replace the example monitor definitions under
`iac/homelab/uptime-kuma/config/` before planning.

Provide the administrator password through a sensitive Terraform variable; do
not write it into the repository:

```bash
cd iac/homelab/uptime-kuma
export TF_VAR_uptime_kuma_base_url='https://uptime-kuma.example.com'
export TF_VAR_uptime_kuma_username='admin'
export TF_VAR_uptime_kuma_password='replace-me'

terraform init
terraform fmt -check -recursive ../..
terraform validate
terraform plan -out=tfplan
terraform show tfplan
```

Apply only after reviewing the plan:

```bash
terraform apply tfplan
```

Terraform state, plans, environment files, credentials, and virtual
environments are excluded by `.gitignore`.

## Security

This repository must contain no passwords, API tokens, Terraform state,
kubeconfigs, or generated credentials. Use environment variables or an
appropriate secret manager for local values, and inspect staged changes before
every push.
