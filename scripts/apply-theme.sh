#!/bin/bash

# Script para aplicar el tema One Dark a GNOME Terminal
# Basado en Gogh - One Dark theme

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Aplicar Tema One Dark${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Instalar dependencias si no están
if ! command -v dconf &> /dev/null || ! command -v uuidgen &> /dev/null; then
    echo -e "${YELLOW}Instalando dependencias...${NC}"
    sudo apt install -y dconf-cli uuid-runtime
fi

# One Dark color scheme
PROFILE_NAME="One Dark"
PROFILE_SLUG="one-dark"

# Generar UUID para el perfil
PROFILE_UUID=$(uuidgen)

# Obtener lista actual de perfiles
PROFILE_LIST=$(dconf read /org/gnome/terminal/legacy/profiles:/list 2>/dev/null || echo "[]")

# Si la lista está vacía o es null, crear una nueva
if [[ -z "$PROFILE_LIST" ]] || [[ "$PROFILE_LIST" == "[]" ]] || [[ "$PROFILE_LIST" == "@as []" ]]; then
    PROFILE_LIST="['$PROFILE_UUID']"
else
    # Eliminar los corchetes y añadir el nuevo UUID
    PROFILE_LIST=$(echo "$PROFILE_LIST" | sed "s/]/, '$PROFILE_UUID']/")
fi

# Crear el perfil
echo -e "${YELLOW}Creando perfil One Dark...${NC}"

# Escribir lista de perfiles
dconf write /org/gnome/terminal/legacy/profiles:/list "$PROFILE_LIST"

# Path del perfil
PROFILE_PATH="/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID"

# Configurar el perfil con los colores de One Dark
dconf write "$PROFILE_PATH/visible-name" "'$PROFILE_NAME'"
dconf write "$PROFILE_PATH/use-theme-colors" "false"
dconf write "$PROFILE_PATH/bold-is-bright" "false"

# Colores One Dark
dconf write "$PROFILE_PATH/foreground-color" "'rgb(171,178,191)'"
dconf write "$PROFILE_PATH/background-color" "'rgb(40,44,52)'"
dconf write "$PROFILE_PATH/palette" "['rgb(0,0,0)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(97,175,239)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(171,178,191)', 'rgb(92,99,112)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(97,175,239)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(255,254,254)']"

# Configuración adicional
dconf write "$PROFILE_PATH/cursor-shape" "'block'"
dconf write "$PROFILE_PATH/cursor-blink-mode" "'off'"
dconf write "$PROFILE_PATH/use-system-font" "false"
dconf write "$PROFILE_PATH/font" "'FiraCode Nerd Font 11'"

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Tema aplicado!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "El perfil '${YELLOW}One Dark${NC}' ha sido creado."
echo ""
echo -e "Para establecerlo como predeterminado:"
echo -e "  1. Abre ${YELLOW}Preferencias de Terminal${NC}"
echo -e "  2. En la pestaña ${YELLOW}Perfiles${NC}, selecciona ${YELLOW}One Dark${NC}"
echo -e "  3. Haz clic en ${YELLOW}Establecer como predeterminado${NC}"
echo ""
echo -e "O establécelo como predeterminado ahora ejecutando:"
echo -e "  ${YELLOW}dconf write /org/gnome/terminal/legacy/profiles:/default \"'$PROFILE_UUID'\"${NC}"
echo ""
