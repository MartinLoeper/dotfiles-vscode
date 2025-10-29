#!/bin/bash

# install.sh - Install lazygit on Debian-based systems
# This script downloads and installs the latest version of lazygit from GitHub releases

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
    print_warning "This script requires root privileges. Restarting with sudo..."
    exec sudo "$0" "$@"
fi

# Check for required dependencies
print_info "Checking for required dependencies..."
MISSING_DEPS=()

if ! command -v wget &> /dev/null; then
    MISSING_DEPS+=("wget")
fi

if ! command -v tar &> /dev/null; then
    MISSING_DEPS+=("tar")
fi

if ! command -v git &> /dev/null; then
    MISSING_DEPS+=("git")
fi

# Install missing dependencies
if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    print_info "Installing missing dependencies: ${MISSING_DEPS[*]}"
    apt-get update
    apt-get install -y "${MISSING_DEPS[@]}"
fi

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        LAZYGIT_ARCH="x86_64"
        ;;
    aarch64|arm64)
        LAZYGIT_ARCH="arm64"
        ;;
    armv7l)
        LAZYGIT_ARCH="armv7"
        ;;
    *)
        print_error "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

print_info "Detected architecture: $ARCH (lazygit: $LAZYGIT_ARCH)"

# Get the latest release version from GitHub
print_info "Fetching latest lazygit release information..."
LATEST_VERSION=$(wget -qO- "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    print_error "Failed to fetch latest version information"
    exit 1
fi

print_info "Latest version: $LATEST_VERSION"

# Construct download URL
DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LATEST_VERSION}/lazygit_${LATEST_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
print_info "Download URL: $DOWNLOAD_URL"

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

print_info "Downloading lazygit..."
if ! wget -q --show-progress -O "$TMP_DIR/lazygit.tar.gz" "$DOWNLOAD_URL"; then
    print_error "Failed to download lazygit"
    exit 1
fi

# Extract the archive
print_info "Extracting archive..."
if ! tar -xzf "$TMP_DIR/lazygit.tar.gz" -C "$TMP_DIR"; then
    print_error "Failed to extract archive"
    exit 1
fi

# Install binary to /usr/local/bin
print_info "Installing lazygit to /usr/local/bin..."
if ! install -m 755 "$TMP_DIR/lazygit" /usr/local/bin/lazygit; then
    print_error "Failed to install lazygit"
    exit 1
fi

# Verify installation
if command -v lazygit &> /dev/null; then
    INSTALLED_VERSION=$(lazygit --version | head -n1)
    print_info "Successfully installed: $INSTALLED_VERSION"
    print_info "You can now run 'lazygit' from anywhere in your terminal"
else
    print_error "Installation completed but lazygit command not found"
    exit 1
fi

print_info "Installation complete!"
