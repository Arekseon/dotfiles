# dotfiles

My shell configuration for consistent terminal experience across MacBooks and Linux servers.

## What's included

- `.zshrc` — zsh configuration
- `.bashrc` — bash configuration (for bash-only servers)
- `.zshenv` — environment variables
- `.tmux.conf` — tmux configuration
- `.zsh/welcome.zsh` — welcome message for local shells
- `.zsh/welcome-ssh.zsh` — welcome message for SSH sessions
- `ghostty.config` — Ghostty terminal config (macOS only)
- `ansible/` — Ansible playbooks to deploy everything

## Quick install (Mac/Linux servers)

```bash
git clone https://github.com/arekseon/dotfiles.git ~/dotfiles
cd ~/dotfiles/ansible
ansible-playbook -i inventory.ini playbooks/site.yml --ask-become-pass
```

Update `inventory.ini` with your hosts first.

## Quick install (WSL/Linux desktop)

```bash
# Run directly
curl -sL https://raw.githubusercontent.com/arekseon/dotfiles/main/wsl-install.sh | bash

# Or clone and run locally
git clone https://github.com/arekseon/dotfiles.git ~/dotfiles
~/dotfiles/wsl-install.sh
```

The script will:
1. Install ansible if not present
2. Clone the dotfiles repo
3. Run the ansible playbook locally

## Manual install (one machine)

```bash
./install.sh
```

This just creates symlinks — no ansible required.

## Updating

After making changes:

```bash
git add .
git commit -m "Your changes"
git push

# Then deploy to all machines
ansible-playbook -i inventory.ini playbooks/site.yml --ask-become-pass
```

## Inventory

Edit `ansible/inventory.ini` to add your machines:

```ini
[macbooks]
mba_m4     ansible_host=10.0.1.100 ansible_user=pk
macmini    ansible_host=10.0.1.101 ansible_user=pk

[linux_zsh]
nuc71      ansible_host=10.0.1.200 ansible_user=pk

[linux_bash]
# Add bash-only servers here
```

## Requirements

- SSH access to target machines
- User with sudo privileges
- Passwordless sudo configured OR use `--ask-become-pass`

## Notes

- `inventory.ini` is NOT committed — keep it local
- Ghostty config only deploys to macOS
- WSL uses the `wsl-install.sh` script
