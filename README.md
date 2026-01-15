# Dotfiles

Configuraciones personales para Pop!_OS (COSMIC). Repositorio con archivos de configuración y scripts para replicar mi entorno de desarrollo.

## Estructura

```
dotfiles/
├── shell/                 # Configuración de shell
│   ├── .zshrc            # Zsh con Oh My Zsh + Powerlevel10k
│   ├── .bashrc           # Bash
│   ├── .bash_aliases     # Alias de Bash
│   ├── .profile          # Variables de entorno de sesión
│   ├── .p10k.zsh         # Tema Powerlevel10k
│   └── .hidden           # Carpetas ocultas en Files
├── git/
│   └── .gitconfig        # Git con firma SSH
├── config/
│   ├── gh/               # GitHub CLI
│   └── mimeapps/         # Aplicaciones por defecto
├── claude/
│   ├── settings.json     # Config de Claude Code
│   └── CLAUDE.md         # Perfil personal de Claude
├── vscode/               # Solo referencia (usa Settings Sync)
├── scripts/
│   └── setup-packages.sh # Instalación de paquetes
└── install.sh            # Crea symlinks
```

## Instalación

### 1. Clonar el repositorio

```bash
git clone git@github.com:adrianreinag/dotfiles.git ~/Dev/Src/dotfiles
cd ~/Dev/Src/dotfiles
```

### 2. Crear symlinks

```bash
./install.sh
```

### 3. (Opcional) Instalar paquetes

```bash
./scripts/setup-packages.sh
```

## Symlinks

El script `install.sh` crea estos symlinks:

| Destino | Origen |
|---------|--------|
| `~/.zshrc` | `shell/.zshrc` |
| `~/.bashrc` | `shell/.bashrc` |
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
- **FVM** para gestionar versiones de Flutter
- **Docker** y Docker Compose

### Aliases incluidos

```bash
ll    # eza -la --icons
la    # eza -a --icons
lt    # eza --tree --icons
bat   # batcat (cat con syntax highlighting)
avenv # source .venv/bin/activate
```

## Modificar configuraciones

Los cambios en los archivos del sistema se reflejan automáticamente en el repo gracias a los symlinks:

```bash
# Editar
nano ~/.zshrc

# Commit
cd ~/Dev/Src/dotfiles
git add -A
git commit -m "Actualizar zshrc"
git push
```

## Sincronizar en otra máquina

```bash
cd ~/Dev/Src/dotfiles
git pull
# Los cambios se aplican automáticamente
```

## Restaurar backups

`install.sh` crea backups automáticos antes de crear symlinks:

```bash
# Restaurar
rm ~/.zshrc
mv ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
```

## Notas

- **VSCode**: Se sincroniza con Settings Sync (GitHub), no con symlinks
- **Docker**: Cerrar sesión y volver a entrar después de instalar para usarlo sin sudo
- **SSH keys**: Agregar a GitHub tanto como Authentication Key como Signing Key

## Requisitos

- Pop!_OS 24.04+ (o Ubuntu 24.04+)
- Git
- Zsh

## Licencia

MIT
