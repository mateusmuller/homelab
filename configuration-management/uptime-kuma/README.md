# Uptime Kuma

Installs Uptime Kuma on Debian/Raspbian running on an ARMv6 Raspberry Pi. The
playbook installs a pinned unofficial Node.js ARMv6 build, compiles SQLite, and
creates a systemd service listening on port 80.

```bash
ansible-playbook -i inventory.ini playbook.yml --syntax-check
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

The preflight assertion intentionally rejects other architectures. Review the
pinned Node.js and Uptime Kuma versions and checksums before upgrading.
