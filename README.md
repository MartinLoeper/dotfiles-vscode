# dotfiles-vscode
My vscode dotfiles for most devcontainer cases

## Installation

### Installing lazygit

The repository includes an installation script for lazygit, a terminal UI for Git commands.

To install lazygit on a Debian-based system:

```bash
sudo ./install.sh
```

The script will:
- Automatically detect your system architecture
- Install required dependencies (git, wget, tar)
- Download the latest lazygit release from GitHub
- Install lazygit to `/usr/local/bin`

Supported architectures: x86_64, arm64, armv7
