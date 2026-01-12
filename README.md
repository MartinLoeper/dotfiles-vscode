# dotfiles-vscode
My vscode dotfiles for most devcontainer cases

## Installation

### Main Installation Script

The repository includes a comprehensive installation script that sets up essential development tools.

To install all packages:

```bash
./install.sh
```

The script will automatically request sudo privileges if needed. You can also run it directly with sudo:

```bash
sudo ./install.sh
```

The main installation script will install:
- **lazygit** - A terminal UI for Git commands
- **Node.js and npm** - JavaScript runtime and package manager
- **Claude Code CLI** - AI-powered coding assistant
- **gum** - Tool for glamorous shell scripts with interactive UI components
- **mloeper-install** - Interactive installer for optional software packages

The script will:
- Automatically detect your system architecture
- Install required dependencies
- Download and install all packages
- Provide a detailed installation summary

Supported architectures: x86_64, arm64, armv7

### Optional Software Installation

After running the main installation script, you can use the `mloeper-install` command to install additional optional software packages interactively:

```bash
mloeper-install
```

This interactive installer provides a user-friendly menu (powered by gum) to select and install optional packages such as:
- **omnara** - Additional development tool
