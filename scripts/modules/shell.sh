#!/bin/bash
# Module: shell.sh - Zsh, Oh My Zsh, and Powerlevel10k

set -e

source "$(dirname "$0")/common.sh"

print_header "Configurando Shell"

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Powerlevel10k
    print_info "Instalando Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    # Plugins
    print_info "Instalando plugins de zsh..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
else
    print_success "Oh My Zsh ya está instalado"
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Cambiando shell por defecto a zsh..."
    chsh -s "$(which zsh)"
fi

print_success "Shell configurado"
