#!/bin/bash
# Validate dotfiles installation
# Checks symlinks and installed commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/common.sh"

ERRORS=0
WARNINGS=0

check_symlink() {
    local link="$1"
    local name="$2"

    if [ -L "$link" ]; then
        if [ -e "$link" ]; then
            print_success "$name"
        else
            print_error "$name (broken symlink)"
            ((ERRORS++))
        fi
    elif [ -e "$link" ]; then
        print_warning "$name (exists but not a symlink)"
        ((WARNINGS++))
    else
        print_error "$name (missing)"
        ((ERRORS++))
    fi
}

check_command() {
    local cmd="$1"
    local name="${2:-$1}"

    if command_exists "$cmd"; then
        print_success "$name"
    else
        print_warning "$name (not installed)"
        ((WARNINGS++))
    fi
}

check_dir() {
    local dir="$1"
    local name="$2"

    if [ -d "$dir" ]; then
        print_success "$name"
    else
        print_warning "$name (missing)"
        ((WARNINGS++))
    fi
}

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Validating Dotfiles Installation${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check symlinks
print_header "Symlinks"
check_symlink ~/.zshrc ".zshrc"
check_symlink ~/.bashrc ".bashrc"
check_symlink ~/.bash_aliases ".bash_aliases"
check_symlink ~/.profile ".profile"
check_symlink ~/.p10k.zsh ".p10k.zsh"
check_symlink ~/.hidden ".hidden"
check_symlink ~/.gitconfig ".gitconfig"
check_symlink ~/.shellrc ".shellrc"
check_symlink ~/.inputrc ".inputrc"
check_symlink ~/.config/gh ".config/gh"
check_symlink ~/.config/mimeapps.list ".config/mimeapps.list"
check_symlink ~/.claude/settings.json ".claude/settings.json"
check_symlink ~/.claude/CLAUDE.md ".claude/CLAUDE.md"

# Check directories
print_header "Directories"
check_dir ~/.oh-my-zsh "Oh My Zsh"
check_dir ~/.oh-my-zsh/custom/themes/powerlevel10k "Powerlevel10k"
check_dir ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions "zsh-autosuggestions"
check_dir ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting "zsh-syntax-highlighting"
check_dir ~/.nvm "NVM"
check_dir ~/.local/share/fonts "Fonts directory"

# Check commands
print_header "Commands"
check_command zsh
check_command git
check_command curl
check_command docker
check_command gh "GitHub CLI"
check_command code "VSCode"
check_command node "Node.js"
check_command eza
check_command batcat "bat"
check_command rg "ripgrep"
check_command fdfind "fd"
check_command micro
check_command jq
check_command claude "Claude CLI"

# Summary
echo ""
echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}=====================================${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}Passed with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}Failed: $ERRORS error(s), $WARNINGS warning(s)${NC}"
    exit 1
fi
