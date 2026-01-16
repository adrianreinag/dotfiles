#!/bin/bash
# Module: fonts.sh - Nerd Fonts installation

set -e

source "$(dirname "$0")/common.sh"

print_header "Instalando fuentes"

FONT_DIR="$HOME/.local/share/fonts"

# Fira Code Nerd Font
if [ ! -f "$FONT_DIR/FiraCodeNerdFont-Regular.ttf" ]; then
    print_info "Instalando Fira Code Nerd Font..."
    mkdir -p "$FONT_DIR"
    cd /tmp
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip -q FiraCode.zip -d FiraCode
    cp FiraCode/*.ttf "$FONT_DIR/"
    rm -rf FiraCode FiraCode.zip
    fc-cache -fv > /dev/null 2>&1
    print_success "Fira Code Nerd Font instalada"
else
    print_success "Fira Code Nerd Font ya está instalada"
fi

print_success "Fuentes instaladas"
