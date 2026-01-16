# Dotfiles

Configuraciones personales para Ubuntu/Pop!_OS. Repositorio con archivos de configuración y scripts modulares para replicar mi entorno de desarrollo.

## Estructura

```
dotfiles/
├── shell/                    # Configuración de shell
│   ├── .zshrc               # Zsh con Oh My Zsh + Powerlevel10k
│   ├── .bashrc              # Bash
│   ├── .shellrc             # Config compartida (NVM, PATH, aliases)
│   ├── .inputrc             # Readline (autocompletado, historial)
│   ├── .bash_aliases        # Alias de Bash
│   ├── .profile             # Variables de entorno de sesión
│   ├── .p10k.zsh            # Tema Powerlevel10k
│   └── .hidden              # Carpetas ocultas en Files
├── git/
│   └── .gitconfig           # Git con firma SSH
├── config/
│   ├── gh/                  # GitHub CLI
│   └── mimeapps/            # Aplicaciones por defecto
├── claude/
│   ├── settings.json        # Config de Claude Code
│   └── CLAUDE.md            # Perfil personal de Claude
├── gnome/                   # Configuración de GNOME (dconf)
│   ├── gnome-shell.dconf
│   ├── gnome-desktop.dconf
│   ├── gnome-terminal.dconf
│   ├── dash-to-panel.dconf
│   └── extensions-list.txt
├── vscode/
│   ├── settings.json        # Referencia (usa Settings Sync)
│   └── extensions.txt       # Lista de extensiones
├── scripts/
│   ├── setup-packages.sh    # Instalador maestro
│   ├── validate.sh          # Validación de instalación
│   ├── export-gnome.sh      # Exportar config de GNOME
│   └── modules/             # Módulos de instalación
│       ├── common.sh        # Funciones compartidas
│       ├── base.sh          # Paquetes esenciales
│       ├── shell.sh         # Zsh, Oh My Zsh
│       ├── git-ssh.sh       # Git y SSH
│       ├── docker.sh        # Docker
│       ├── dev-tools.sh     # NVM, uv, gh, claude
│       ├── cli-modern.sh    # eza, bat, ripgrep, fd
│       ├── fonts.sh         # Nerd Fonts
│       └── apps.sh          # Chrome, VSCode
├── .editorconfig            # Configuración de editores
├── install.sh               # Crea symlinks
└── Makefile                 # Comandos de gestión
```

## Instalación rápida

```bash
# Clonar
git clone git@github.com:adrianreinag/dotfiles.git ~/Dev/Projects/dotfiles
cd ~/Dev/Projects/dotfiles

# Crear symlinks
make install

# Instalar paquetes (opcional)
make packages
```

## Comandos Make

| Comando | Descripción |
|---------|-------------|
| `make install` | Crear symlinks |
| `make packages` | Instalar todos los paquetes |
| `make update` | Actualizar dotfiles (git pull + reinstalar) |
| `make check` | Validar instalación |
| `make export` | Exportar config de GNOME y extensiones |
| `make clean` | Eliminar symlinks |

### Módulos individuales

```bash
make base        # Paquetes esenciales
make shell       # Zsh, Oh My Zsh, Powerlevel10k
make docker      # Docker y Docker Compose
make dev-tools   # NVM, uv, gh, claude
make cli-modern  # eza, bat, ripgrep, fd
make fonts       # Fira Code Nerd Font
make apps        # Chrome, VSCode
```

## Symlinks

El script `install.sh` crea estos symlinks:

| Destino | Origen |
|---------|--------|
| `~/.zshrc` | `shell/.zshrc` |
| `~/.bashrc` | `shell/.bashrc` |
| `~/.shellrc` | `shell/.shellrc` |
| `~/.inputrc` | `shell/.inputrc` |
| `~/.bash_aliases` | `shell/.bash_aliases` |
| `~/.profile` | `shell/.profile` |
| `~/.p10k.zsh` | `shell/.p10k.zsh` |
| `~/.hidden` | `shell/.hidden` |
| `~/.gitconfig` | `git/.gitconfig` |
| `~/.config/gh` | `config/gh` |
| `~/.config/mimeapps.list` | `config/mimeapps/mimeapps.list` |
| `~/.claude/settings.json` | `claude/settings.json` |
| `~/.claude/CLAUDE.md` | `claude/CLAUDE.md` |

## Herramientas configuradas

### Shell
- **Zsh** con Oh My Zsh
- **Powerlevel10k** como tema
- Plugins: git, z, zsh-autosuggestions, zsh-syntax-highlighting, docker

### Desarrollo
- **Git** con firma de commits via SSH
- **NVM** para gestionar versiones de Node.js
- **uv** para gestionar Python
- **FVM** para gestionar versiones de Flutter
- **Docker** y Docker Compose
- **GitHub CLI** y **Claude CLI**

### CLI modernas
- **eza** - ls moderno con iconos
- **bat** - cat con syntax highlighting
- **ripgrep** - grep ultrarrápido
- **fd** - find moderno
- **micro** - editor de terminal
- **jq/yq** - procesadores JSON/YAML

### Aliases incluidos

```bash
ll      # eza -la --icons
la      # eza -a --icons
lt      # eza --tree --icons
bat     # batcat (cat con syntax highlighting)
avenv   # source .venv/bin/activate
flutter # fvm flutter
dart    # fvm dart
```

## Modificar configuraciones

Los cambios se reflejan automáticamente en el repo gracias a los symlinks:

```bash
# Editar
nano ~/.zshrc

# Commit
cd ~/Dev/Projects/dotfiles
git add -A
git commit -m "Actualizar zshrc"
git push
```

## Sincronizar en otra máquina

```bash
cd ~/Dev/Projects/dotfiles
git pull
# Los cambios se aplican automáticamente
```

## Restaurar backups

`install.sh` crea backups automáticos antes de crear symlinks:

```bash
rm ~/.zshrc
mv ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
```

## Notas

- **VSCode**: Se sincroniza con Settings Sync (GitHub), no con symlinks
- **Docker**: Cerrar sesión y volver a entrar después de instalar
- **SSH keys**: Agregar a GitHub como Authentication Key y Signing Key
- **GNOME**: Ejecutar `make export` antes de commit para guardar cambios

## Requisitos

- Pop!_OS 24.04+ (o Ubuntu 24.04+)
- Git
- Zsh

## Licencia

MIT
