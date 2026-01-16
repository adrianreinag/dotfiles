#!/bin/bash
# Module: git-ssh.sh - Git configuration and SSH key setup

set -e

source "$(dirname "$0")/common.sh"

print_header "Configurando Git y SSH"

# Git config
if [ ! -f ~/.gitconfig ]; then
    print_info "Configurando Git..."
    read -p "Nombre para Git: " git_name
    read -p "Email para Git: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
else
    print_success "Git ya está configurado"
fi

# SSH Key
if [ ! -f ~/.ssh/id_ed25519 ]; then
    print_info "Generando SSH key..."
    read -p "Email para SSH key (usar el mismo de GitHub): " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email" -f ~/.ssh/id_ed25519 -N ""

    # Start ssh-agent and add key
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519

    echo ""
    print_success "SSH key generada!"
    print_warning "Copia esta clave pública y agrégala a GitHub:"
    echo -e "${YELLOW}https://github.com/settings/keys${NC}"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    read -p "Presiona Enter cuando hayas agregado la clave a GitHub..."
else
    print_success "SSH key ya existe en ~/.ssh/id_ed25519"
fi

print_success "Git y SSH configurados"
