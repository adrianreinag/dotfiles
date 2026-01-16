#!/bin/bash
# Module: dev-tools.sh - Development tools (NVM, uv, gh, claude)

set -e

source "$(dirname "$0")/common.sh"

print_header "Instalando herramientas de desarrollo"

# NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    print_info "Instalando NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    print_info "Instalando Node.js LTS..."
    nvm install --lts
    nvm use --lts
    print_success "NVM y Node.js instalados"
else
    print_success "NVM ya está instalado"
fi

# uv (Python version manager)
if ! command_exists uv; then
    print_info "Instalando uv (Python)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    print_success "uv instalado"
else
    print_success "uv ya está instalado"
fi

# GitHub CLI
if ! command_exists gh; then
    print_info "Instalando GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
        https://cli.github.com/packages stable main" | \
        sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    sudo apt update
    sudo apt install -y gh
    print_success "GitHub CLI instalado"
else
    print_success "GitHub CLI ya está instalado"
fi

# Claude CLI
if ! command_exists claude; then
    print_info "Instalando Claude CLI..."
    curl -fsSL https://releases.anthropic.com/claude/install.sh | sh
    print_success "Claude CLI instalado"
    print_warning "Ejecuta 'claude auth login' para autenticarte"
else
    print_success "Claude CLI ya está instalado"
fi

print_success "Herramientas de desarrollo instaladas"
