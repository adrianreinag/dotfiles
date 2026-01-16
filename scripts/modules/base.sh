#!/bin/bash
# Module: base.sh - System update and essential packages

set -e

source "$(dirname "$0")/common.sh"

print_header "Actualizando sistema"
sudo apt update && sudo apt upgrade -y

print_header "Instalando paquetes esenciales"
sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    zsh \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    jq

# Flatpak
print_header "Configurando Flatpak"
sudo apt install -y flatpak gnome-software-plugin-flatpak

if ! flatpak remotes | grep -q flathub; then
    print_info "Agregando repositorio Flathub..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

print_success "Paquetes base instalados"
