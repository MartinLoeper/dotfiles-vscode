#!/bin/bash

# install.sh - Main installation script for dotfiles
# This script orchestrates the installation of various packages

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    print_warning "This script requires root privileges. Restarting with sudo (you may be prompted for your password)..."
    exec sudo "$0" "$@"
fi

# Get the directory where install.sh is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install lazygit
print_info "Installing lazygit..."
if [ -f "$SCRIPT_DIR/packages/lazygit.sh" ]; then
    chmod +x "$SCRIPT_DIR/packages/lazygit.sh"
    "$SCRIPT_DIR/packages/lazygit.sh"
else
    print_error "lazygit installation script not found at $SCRIPT_DIR/packages/lazygit.sh"
    exit 1
fi

# Install Claude Code CLI
print_info "Installing Claude Code CLI..."
if [ -f "$SCRIPT_DIR/packages/claude-code.sh" ]; then
    chmod +x "$SCRIPT_DIR/packages/claude-code.sh"
    "$SCRIPT_DIR/packages/claude-code.sh"
else
    print_error "Claude Code installation script not found at $SCRIPT_DIR/packages/claude-code.sh"
    exit 1
fi

print_info "All installations complete!"
