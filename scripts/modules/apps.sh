#!/bin/bash
# Module: apps.sh - Desktop applications (Chrome, VSCode)

set -e

source "$(dirname "$0")/common.sh"

print_header "Instalando aplicaciones de escritorio"

# Google Chrome
if ! command_exists google-chrome; then
    print_info "Instalando Google Chrome..."
    wget -q -O /tmp/google-chrome.deb \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y /tmp/google-chrome.deb
    rm /tmp/google-chrome.deb
    print_success "Google Chrome instalado"
else
    print_success "Google Chrome ya está instalado"
fi

# VSCode
if ! command_exists code; then
    print_info "Instalando VSCode..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg \
        /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
        https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f /tmp/packages.microsoft.gpg

    sudo apt update
    sudo apt install -y code
    print_success "VSCode instalado"
else
    print_success "VSCode ya está instalado"
fi

# Install VSCode extensions if file exists
EXTENSIONS_FILE="$DOTFILES_DIR/vscode/extensions.txt"
if [ -f "$EXTENSIONS_FILE" ] && command_exists code; then
    print_info "Instalando extensiones de VSCode..."
    while IFS= read -r extension || [ -n "$extension" ]; do
        if [ -n "$extension" ] && [[ ! "$extension" =~ ^# ]]; then
            code --install-extension "$extension" --force 2>/dev/null || true
        fi
    done < "$EXTENSIONS_FILE"
    print_success "Extensiones instaladas"
fi

print_success "Aplicaciones instaladas"
