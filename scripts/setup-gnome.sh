#!/bin/bash

# Script para instalar y configurar extensiones de GNOME
# Ejecutar después de setup-packages.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES_DIR="$HOME/projects/dotfiles"

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Configuración de GNOME${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Instalar gnome-shell-extension-manager si no está instalado
echo -e "${YELLOW}Verificando herramientas de GNOME...${NC}"
if ! command -v gnome-extensions &> /dev/null; then
    echo "gnome-shell-extensions no encontrado, instalando..."
    sudo apt install -y gnome-shell-extensions gnome-shell-extension-prefs
fi

# Instalar GNOME Extension Manager oficial
if ! command -v gnome-shell-extension-manager &> /dev/null; then
    echo ""
    echo -e "${YELLOW}Instalando GNOME Extension Manager (oficial)...${NC}"
    sudo apt install -y gnome-shell-extension-manager
fi

# Función para instalar extensión desde extensions.gnome.org
install_gnome_extension() {
    local extension_id="$1"
    local extension_name="$2"

    echo "Descargando $extension_name..."

    # Obtener la versión de GNOME Shell
    GNOME_VERSION=$(gnome-shell --version | cut -d' ' -f3 | cut -d'.' -f1)

    # Descargar info de la extensión
    EXTENSION_INFO=$(wget -q -O- "https://extensions.gnome.org/extension-info/?pk=${extension_id}&shell_version=${GNOME_VERSION}")

    if [ -z "$EXTENSION_INFO" ]; then
        echo -e "${RED}No se pudo obtener información de $extension_name para GNOME $GNOME_VERSION${NC}"
        echo -e "${YELLOW}Instálalo manualmente desde: https://extensions.gnome.org/extension/${extension_id}/${NC}"
        return 1
    fi

    # Extraer URL de descarga
    DOWNLOAD_URL=$(echo "$EXTENSION_INFO" | grep -o '"download_url":"[^"]*"' | cut -d'"' -f4)

    if [ -z "$DOWNLOAD_URL" ]; then
        echo -e "${RED}No se encontró versión compatible de $extension_name para GNOME $GNOME_VERSION${NC}"
        echo -e "${YELLOW}Instálalo manualmente desde: https://extensions.gnome.org/extension/${extension_id}/${NC}"
        return 1
    fi

    # Descargar y extraer extensión
    EXTENSION_UUID=$(echo "$EXTENSION_INFO" | grep -o '"uuid":"[^"]*"' | cut -d'"' -f4)
    EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID"

    mkdir -p "$HOME/.local/share/gnome-shell/extensions"
    wget -q -O "/tmp/${EXTENSION_UUID}.zip" "https://extensions.gnome.org${DOWNLOAD_URL}"

    if [ -d "$EXTENSION_DIR" ]; then
        rm -rf "$EXTENSION_DIR"
    fi

    mkdir -p "$EXTENSION_DIR"
    unzip -q "/tmp/${EXTENSION_UUID}.zip" -d "$EXTENSION_DIR"
    rm "/tmp/${EXTENSION_UUID}.zip"

    echo -e "${GREEN}$extension_name instalado correctamente${NC}"
    return 0
}

# Instalar extensiones desde la lista
echo ""
echo -e "${YELLOW}Instalando extensiones de GNOME...${NC}"

# Dash to Panel
if ! gnome-extensions list | grep -q "dash-to-panel"; then
    echo "Instalando Dash to Panel..."
    # Intentar instalar desde extensions.gnome.org
    if ! install_gnome_extension "1160" "Dash to Panel"; then
        echo -e "${YELLOW}No hay versión estable para GNOME 46${NC}"
        echo -e "${YELLOW}Instálalo manualmente con Extension Manager:${NC}"
        echo -e "  ${YELLOW}gnome-shell-extension-manager${NC}"
        echo -e "${YELLOW}O desde el navegador:${NC}"
        echo -e "  ${YELLOW}https://extensions.gnome.org/extension/1160/dash-to-panel/${NC}"
    else
        gnome-extensions enable dash-to-panel@jderose9.github.com 2>/dev/null || true
    fi
else
    echo "Dash to Panel ya está instalado"
fi

# Desktop Icons NG (DING) - ya viene preinstalado en Ubuntu
if gnome-extensions list | grep -q "ding@rastersoft.com"; then
    echo "DING (Desktop Icons) ya está instalado"
fi

# Tiling Assistant - ya viene preinstalado en Ubuntu
if gnome-extensions list | grep -q "tiling-assistant"; then
    echo "Tiling Assistant ya está instalado"
fi

# Restaurar configuración de GNOME desde archivos dconf
echo ""
echo -e "${YELLOW}Restaurando configuración de GNOME...${NC}"

if [ -f "$DOTFILES_DIR/gnome/dash-to-panel.conf" ]; then
    echo "Restaurando configuración de Dash to Panel..."
    dconf load /org/gnome/shell/extensions/dash-to-panel/ < "$DOTFILES_DIR/gnome/dash-to-panel.conf"
fi

if [ -f "$DOTFILES_DIR/gnome/gnome-shell.conf" ]; then
    echo "Restaurando configuración de GNOME Shell..."
    dconf load /org/gnome/shell/ < "$DOTFILES_DIR/gnome/gnome-shell.conf"
fi

if [ -f "$DOTFILES_DIR/gnome/gnome-desktop.conf" ]; then
    echo "Restaurando configuración de GNOME Desktop..."
    dconf load /org/gnome/desktop/ < "$DOTFILES_DIR/gnome/gnome-desktop.conf"
fi

# Habilitar extensiones
echo ""
echo -e "${YELLOW}Habilitando extensiones...${NC}"
if [ -f "$DOTFILES_DIR/gnome/extensions-list.txt" ]; then
    while IFS= read -r extension; do
        if [ ! -z "$extension" ]; then
            gnome-extensions enable "$extension" 2>/dev/null || echo "No se pudo habilitar: $extension"
        fi
    done < "$DOTFILES_DIR/gnome/extensions-list.txt"
fi

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Configuración completada!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${YELLOW}IMPORTANTE: Debes reiniciar GNOME Shell para aplicar los cambios${NC}"
echo ""
echo -e "Opciones para reiniciar GNOME Shell:"
echo -e "  1. ${YELLOW}Cerrar sesión y volver a entrar${NC} (recomendado)"
echo -e "  2. Si usas X11: ${YELLOW}Alt+F2${NC}, escribe ${YELLOW}r${NC} y presiona Enter"
echo -e "  3. Si usas Wayland: debes cerrar sesión obligatoriamente"
echo ""
echo -e "Para verificar que las extensiones están activas:"
echo -e "  ${YELLOW}gnome-extensions list --enabled${NC}"
echo ""
echo -e "Si alguna extensión no se instaló correctamente:"
echo -e "  Abre Extension Manager: ${YELLOW}gnome-shell-extension-manager${NC}"
echo ""
echo -e "Para exportar cambios futuros de configuración:"
echo -e "  ${YELLOW}cd ~/projects/dotfiles && ./scripts/export-gnome.sh${NC}"
echo ""
