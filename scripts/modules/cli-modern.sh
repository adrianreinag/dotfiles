#!/bin/bash
# Module: cli-modern.sh - Modern CLI tools (eza, bat, ripgrep, fd, etc.)

set -e

source "$(dirname "$0")/common.sh"

print_header "Instalando herramientas CLI modernas"

# bat (cat with syntax highlighting)
if ! command_exists batcat; then
    print_info "Instalando bat..."
    sudo apt install -y bat
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
    print_success "bat instalado"
else
    print_success "bat ya está instalado"
fi

# eza (modern ls)
if ! command_exists eza; then
    print_info "Instalando eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | \
        sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | \
        sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
    print_success "eza instalado"
else
    print_success "eza ya está instalado"
fi

# ripgrep (better grep)
if ! command_exists rg; then
    print_info "Instalando ripgrep..."
    sudo apt install -y ripgrep
    print_success "ripgrep instalado"
else
    print_success "ripgrep ya está instalado"
fi

# fd (better find)
if ! command_exists fdfind; then
    print_info "Instalando fd..."
    sudo apt install -y fd-find
    ln -sf /usr/bin/fdfind ~/.local/bin/fd 2>/dev/null || true
    print_success "fd instalado"
else
    print_success "fd ya está instalado"
fi

# tldr (simplified man pages)
if ! command_exists tldr; then
    print_info "Instalando tldr..."
    sudo apt install -y tldr
    print_success "tldr instalado"
else
    print_success "tldr ya está instalado"
fi

# micro (modern terminal editor)
if ! command_exists micro; then
    print_info "Instalando micro..."
    cd /tmp
    curl https://getmic.ro | bash
    sudo mv micro /usr/local/bin/
    print_success "micro instalado"
else
    print_success "micro ya está instalado"
fi

# jq and yq (JSON/YAML processors)
if ! command_exists jq; then
    sudo apt install -y jq
fi

if ! command_exists yq; then
    print_info "Instalando yq..."
    sudo wget -qO /usr/local/bin/yq \
        https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq
    print_success "yq instalado"
fi

print_success "Herramientas CLI modernas instaladas"
