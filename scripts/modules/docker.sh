#!/bin/bash
# Module: docker.sh - Docker and Docker Compose

set -e

source "$(dirname "$0")/common.sh"

print_header "Instalando Docker"

if ! command_exists docker; then
    print_info "Agregando repositorio de Docker..."

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Add user to docker group
    sudo usermod -aG docker "$USER"

    print_success "Docker instalado"
    print_warning "Cierra sesión y vuelve a entrar para usar Docker sin sudo"
else
    print_success "Docker ya está instalado"
fi
