#!/bin/bash

# Script para aplicar el tema One Dark (247) usando Gogh
# https://gogh-co.github.io/Gogh/

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Instalando tema One Dark para Terminal${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Verificar que estamos en GNOME Terminal
if [ -z "$GNOME_TERMINAL_SERVICE" ] && [ ! -d "/org/gnome/terminal" ]; then
    echo -e "${YELLOW}Nota: Este script está optimizado para GNOME Terminal${NC}"
fi

# Instalar dependencias
echo -e "${YELLOW}Instalando dependencias...${NC}"
sudo apt install -y dconf-cli uuid-runtime

# Aplicar tema One Dark usando Gogh
echo ""
echo -e "${YELLOW}Aplicando tema One Dark (247)...${NC}"

# Descargar y ejecutar Gogh con el tema One Dark
export TERMINAL=gnome-terminal

# One Dark es el tema 247 en Gogh
bash -c "$(wget -qO- https://git.io/vQgMr)" <<< "247"

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Tema One Dark instalado${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${YELLOW}Para establecer como perfil predeterminado:${NC}"
echo -e "  1. Abre GNOME Terminal"
echo -e "  2. Click derecho -> Preferencias"
echo -e "  3. En 'Perfiles', selecciona 'One Dark' y marca como predeterminado"
echo ""
