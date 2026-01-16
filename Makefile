# Dotfiles Makefile
# Usage: make [target]

.PHONY: help install packages update check export clean

DOTFILES_DIR := $(shell pwd)
SHELL := /bin/bash

# Default target
help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install    Create symlinks for dotfiles"
	@echo "  packages   Install all packages (runs setup-packages.sh)"
	@echo "  update     Pull latest changes and reinstall symlinks"
	@echo "  check      Validate symlinks and dependencies"
	@echo "  export     Export GNOME settings and VSCode extensions"
	@echo "  clean      Remove symlinks (keeps backups)"
	@echo ""
	@echo "Module targets (install specific packages):"
	@echo "  base       System update and essential packages"
	@echo "  shell      Zsh, Oh My Zsh, Powerlevel10k"
	@echo "  docker     Docker and Docker Compose"
	@echo "  dev-tools  NVM, uv, gh, claude"
	@echo "  cli-modern eza, bat, ripgrep, fd, etc."
	@echo "  fonts      Fira Code Nerd Font"
	@echo "  apps       Chrome, VSCode"

install:
	@echo "Creating symlinks..."
	@./install.sh

packages:
	@echo "Installing packages..."
	@./scripts/setup-packages.sh

update:
	@echo "Updating dotfiles..."
	@git pull
	@./install.sh
	@echo "Done! Restart your terminal to apply changes."

check:
	@echo "Validating dotfiles..."
	@./scripts/validate.sh

export:
	@echo "Exporting configurations..."
	@./scripts/export-gnome.sh 2>/dev/null || true
	@code --list-extensions > vscode/extensions.txt 2>/dev/null || true
	@echo "Done! Check gnome/ and vscode/extensions.txt"

clean:
	@echo "Removing symlinks..."
	@rm -f ~/.zshrc ~/.bashrc ~/.bash_aliases ~/.profile ~/.p10k.zsh ~/.hidden
	@rm -f ~/.gitconfig ~/.inputrc ~/.shellrc
	@rm -f ~/.config/mimeapps.list
	@rm -rf ~/.config/gh
	@rm -f ~/.claude/settings.json ~/.claude/CLAUDE.md
	@echo "Symlinks removed. Backups preserved."

# Module targets
base:
	@./scripts/setup-packages.sh base

shell:
	@./scripts/setup-packages.sh shell

docker:
	@./scripts/setup-packages.sh docker

dev-tools:
	@./scripts/setup-packages.sh dev-tools

cli-modern:
	@./scripts/setup-packages.sh cli-modern

fonts:
	@./scripts/setup-packages.sh fonts

apps:
	@./scripts/setup-packages.sh apps
