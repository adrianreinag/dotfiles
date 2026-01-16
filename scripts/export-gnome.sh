#!/bin/bash

# Script para exportar configuración de GNOME al repositorio
# Ejecutar antes de hacer commit de cambios de GNOME

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES_DIR="$HOME/Dev/Projects/dotfiles"
GNOME_DIR="$DOTFILES_DIR/gnome"

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Exportando configuración de GNOME${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Crear directorio si no existe
mkdir -p "$GNOME_DIR"

# Exportar configuración de Dash to Panel
echo -e "${YELLOW}Exportando Dash to Panel...${NC}"
if dconf dump /org/gnome/shell/extensions/dash-to-panel/ > /dev/null 2>&1; then
    dconf dump /org/gnome/shell/extensions/dash-to-panel/ > "$GNOME_DIR/dash-to-panel.dconf"
    echo -e "${GREEN}✓${NC} dash-to-panel.dconf"
else
    echo -e "${YELLOW}⚠${NC} Dash to Panel no configurado o no instalado"
fi

# Exportar configuración de GNOME Shell
echo -e "${YELLOW}Exportando GNOME Shell...${NC}"
dconf dump /org/gnome/shell/ > "$GNOME_DIR/gnome-shell.dconf"
echo -e "${GREEN}✓${NC} gnome-shell.dconf"

# Exportar configuración de Desktop
echo -e "${YELLOW}Exportando configuración de Desktop...${NC}"
dconf dump /org/gnome/desktop/ > "$GNOME_DIR/gnome-desktop.dconf"
echo -e "${GREEN}✓${NC} gnome-desktop.dconf"

# Exportar configuración de Terminal
echo -e "${YELLOW}Exportando GNOME Terminal...${NC}"
dconf dump /org/gnome/terminal/ > "$GNOME_DIR/gnome-terminal.dconf"
echo -e "${GREEN}✓${NC} gnome-terminal.dconf"

# Exportar lista de extensiones instaladas
echo -e "${YELLOW}Exportando lista de extensiones...${NC}"
if command -v gnome-extensions &> /dev/null; then
    gnome-extensions list > "$GNOME_DIR/extensions-list.txt"
    echo -e "${GREEN}✓${NC} extensions-list.txt"
else
    # Método alternativo usando dconf
    dconf read /org/gnome/shell/enabled-extensions | tr "'" '"' | tr -d '[]' | tr ',' '\n' | sed 's/^ *//' > "$GNOME_DIR/extensions-list.txt"
    echo -e "${GREEN}✓${NC} extensions-list.txt (via dconf)"
fi

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Exportación completada${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "Archivos guardados en: ${YELLOW}$GNOME_DIR${NC}"
echo ""
echo -e "Para guardar los cambios:"
echo -e "  cd $DOTFILES_DIR"
echo -e "  git add gnome/"
echo -e "  git commit -m 'Actualizar configuración de GNOME'"
echo ""
