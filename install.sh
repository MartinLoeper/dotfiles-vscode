#!/bin/bash

# install.sh - Main installation script for dotfiles
# This script orchestrates the installation of various packages

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

# Track installation success/failure
FAILED_PACKAGES=()
SUCCESSFUL_PACKAGES=()

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
    if "$SCRIPT_DIR/packages/lazygit.sh"; then
        SUCCESSFUL_PACKAGES+=("lazygit")
    else
        print_error "lazygit installation failed"
        FAILED_PACKAGES+=("lazygit")
    fi
else
    print_error "lazygit installation script not found at $SCRIPT_DIR/packages/lazygit.sh"
    FAILED_PACKAGES+=("lazygit")
fi

# Install Node.js and npm
print_info "Installing Node.js and npm..."
if [ -f "$SCRIPT_DIR/packages/nodejs.sh" ]; then
    chmod +x "$SCRIPT_DIR/packages/nodejs.sh"
    if "$SCRIPT_DIR/packages/nodejs.sh"; then
        SUCCESSFUL_PACKAGES+=("nodejs")
    else
        print_error "Node.js installation failed"
        FAILED_PACKAGES+=("nodejs")
    fi
else
    print_error "Node.js installation script not found at $SCRIPT_DIR/packages/nodejs.sh"
    FAILED_PACKAGES+=("nodejs")
fi

# Install Claude Code CLI
# Note: This depends on nodejs.sh above (requires npm)
print_info "Installing Claude Code CLI..."
if [ -f "$SCRIPT_DIR/packages/claude-code.sh" ]; then
    chmod +x "$SCRIPT_DIR/packages/claude-code.sh"
    if "$SCRIPT_DIR/packages/claude-code.sh"; then
        SUCCESSFUL_PACKAGES+=("claude-code")
    else
        print_error "Claude Code CLI installation failed"
        FAILED_PACKAGES+=("claude-code")
    fi
else
    print_error "Claude Code installation script not found at $SCRIPT_DIR/packages/claude-code.sh"
    FAILED_PACKAGES+=("claude-code")
fi

# Print installation summary
echo ""
print_info "Installation Summary:"
print_info "===================="

if [ ${#SUCCESSFUL_PACKAGES[@]} -gt 0 ]; then
    print_info "Successfully installed (${#SUCCESSFUL_PACKAGES[@]}):"
    for pkg in "${SUCCESSFUL_PACKAGES[@]}"; do
        echo -e "  ${GREEN}✓${NC} $pkg"
    done
fi

if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    echo ""
    print_error "Failed installations (${#FAILED_PACKAGES[@]}):"
    for pkg in "${FAILED_PACKAGES[@]}"; do
        echo -e "  ${RED}✗${NC} $pkg"
    done
    echo ""
    print_warning "Some packages failed to install. Please check the errors above."
    exit 1
else
    echo ""
    print_info "All installations complete!"
fi
