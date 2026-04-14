# Dotfiles

Personal dotfiles for shell and Git, managed with a bare Git repo.

## Install on a new machine

```bash
bash <(curl -s https://raw.githubusercontent.com/lsamon/dotfiles/main/install.sh)
```

## Daily usage

```bash
dotfiles status
dotfiles add ~/.bashrc
dotfiles commit -m "update bashrc"
dotfiles push
```

## What's tracked

- `~/.bashrc` — shell config and aliases
- `~/.gitconfig` — Git settings and aliases
- `~/.gitignore_global` — global gitignore rules
- `~/install.sh` — bootstrap script for new machines
