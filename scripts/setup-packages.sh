#!/bin/bash
# Master installation script - calls modular scripts
# Usage: ./setup-packages.sh [module...]
# Without arguments, runs all modules in order

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

source "$MODULES_DIR/common.sh"

# Available modules in order
ALL_MODULES=(
    "base"
    "shell"
    "git-ssh"
    "docker"
    "dev-tools"
    "cli-modern"
    "fonts"
    "apps"
)

show_help() {
    echo "Usage: $0 [module...]"
    echo ""
    echo "Available modules:"
    for mod in "${ALL_MODULES[@]}"; do
        echo "  - $mod"
    done
    echo ""
    echo "Examples:"
    echo "  $0              # Run all modules"
    echo "  $0 base shell   # Run only base and shell"
    echo "  $0 docker       # Run only docker"
}

run_module() {
    local module="$1"
    local module_script="$MODULES_DIR/$module.sh"

    if [ -f "$module_script" ]; then
        print_header "Ejecutando módulo: $module"
        bash "$module_script"
    else
        print_error "Módulo no encontrado: $module"
        return 1
    fi
}

# Main
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Instalación de Paquetes Ubuntu${NC}"
echo -e "${GREEN}=====================================${NC}"

# Parse arguments
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Determine which modules to run
if [ $# -eq 0 ]; then
    MODULES_TO_RUN=("${ALL_MODULES[@]}")
else
    MODULES_TO_RUN=("$@")
fi

# Run modules
for module in "${MODULES_TO_RUN[@]}"; do
    run_module "$module"
done

# Final message
echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Instalación completada!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${YELLOW}Siguiente paso - crear symlinks:${NC}"
echo -e "  cd ~/Dev/Projects/dotfiles && ./install.sh"
echo ""
echo -e "Notas importantes:"
echo -e "  - Reinicia tu terminal para aplicar los cambios de zsh"
echo -e "  - Si instalaste Docker, cierra sesión y vuelve a entrar"
echo ""
echo -e "Autenticación de servicios:"
echo -e "  - GitHub CLI:   ${YELLOW}gh auth login${NC}"
echo -e "  - Claude CLI:   ${YELLOW}claude auth login${NC}"
echo ""
