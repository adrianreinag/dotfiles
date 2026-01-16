#!/bin/bash

# Script para restaurar configuración de GNOME desde el repositorio
# Ejecutar después de clonar el repositorio en una nueva instalación

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES_DIR="$HOME/Dev/Projects/dotfiles"
GNOME_DIR="$DOTFILES_DIR/gnome"

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Configurando GNOME Desktop${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Verificar que existe el directorio gnome
if [ ! -d "$GNOME_DIR" ]; then
    echo -e "${RED}Error: No se encontró el directorio $GNOME_DIR${NC}"
    echo -e "Ejecuta primero: ./scripts/export-gnome.sh en otra máquina configurada"
    exit 1
fi

# Instalar Dash to Panel
echo -e "${YELLOW}Instalando extensión Dash to Panel...${NC}"
if ! gnome-extensions list 2>/dev/null | grep -q "dash-to-panel"; then
    # Obtener versión de GNOME Shell
    GNOME_VERSION=$(gnome-shell --version | grep -oP '\d+' | head -1)

    # Descargar e instalar Dash to Panel
    EXTENSION_URL="https://extensions.gnome.org/extension-data/dash-to-paneljderose9.github.com.v"

    # Intentar instalar via apt si está disponible
    if apt-cache show gnome-shell-extension-dash-to-panel &> /dev/null; then
        sudo apt install -y gnome-shell-extension-dash-to-panel
        echo -e "${GREEN}✓${NC} Dash to Panel instalado via apt"
    else
        echo -e "${YELLOW}⚠${NC} Instala Dash to Panel manualmente desde:"
        echo -e "  https://extensions.gnome.org/extension/1160/dash-to-panel/"
    fi
else
    echo -e "${GREEN}✓${NC} Dash to Panel ya está instalado"
fi

# Cargar configuración de Dash to Panel
echo ""
echo -e "${YELLOW}Cargando configuración de Dash to Panel...${NC}"
if [ -f "$GNOME_DIR/dash-to-panel.dconf" ]; then
    dconf load /org/gnome/shell/extensions/dash-to-panel/ < "$GNOME_DIR/dash-to-panel.dconf"
    echo -e "${GREEN}✓${NC} Configuración de Dash to Panel cargada"
else
    echo -e "${YELLOW}⚠${NC} No se encontró dash-to-panel.dconf"
fi

# Cargar configuración de GNOME Shell
echo ""
echo -e "${YELLOW}Cargando configuración de GNOME Shell...${NC}"
if [ -f "$GNOME_DIR/gnome-shell.dconf" ]; then
    dconf load /org/gnome/shell/ < "$GNOME_DIR/gnome-shell.dconf"
    echo -e "${GREEN}✓${NC} Configuración de GNOME Shell cargada"
else
    echo -e "${YELLOW}⚠${NC} No se encontró gnome-shell.dconf"
fi

# Cargar configuración de Desktop
echo ""
echo -e "${YELLOW}Cargando configuración de Desktop...${NC}"
if [ -f "$GNOME_DIR/gnome-desktop.dconf" ]; then
    dconf load /org/gnome/desktop/ < "$GNOME_DIR/gnome-desktop.dconf"
    echo -e "${GREEN}✓${NC} Configuración de Desktop cargada"
else
    echo -e "${YELLOW}⚠${NC} No se encontró gnome-desktop.dconf"
fi

# Cargar configuración de Terminal
echo ""
echo -e "${YELLOW}Cargando configuración de GNOME Terminal...${NC}"
if [ -f "$GNOME_DIR/gnome-terminal.dconf" ]; then
    dconf load /org/gnome/terminal/ < "$GNOME_DIR/gnome-terminal.dconf"
    echo -e "${GREEN}✓${NC} Configuración de Terminal cargada"
else
    echo -e "${YELLOW}⚠${NC} No se encontró gnome-terminal.dconf"
fi

# Habilitar extensiones
echo ""
echo -e "${YELLOW}Habilitando extensiones...${NC}"
if [ -f "$GNOME_DIR/extensions-list.txt" ]; then
    while IFS= read -r extension; do
        if [ ! -z "$extension" ]; then
            gnome-extensions enable "$extension" 2>/dev/null || echo -e "${YELLOW}⚠${NC} No se pudo habilitar: $extension"
        fi
    done < "$GNOME_DIR/extensions-list.txt"
    echo -e "${GREEN}✓${NC} Extensiones procesadas"
else
    echo -e "${YELLOW}⚠${NC} No se encontró extensions-list.txt"
fi

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Configuración de GNOME completada${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${YELLOW}IMPORTANTE: Debes cerrar sesión y volver a entrar${NC}"
echo -e "${YELLOW}para que los cambios surtan efecto.${NC}"
echo ""
echo -e "Alternativa: Reiniciar GNOME Shell con Alt+F2 -> 'r' -> Enter"
echo -e "(Solo funciona en sesión X11, no en Wayland)"
echo ""
