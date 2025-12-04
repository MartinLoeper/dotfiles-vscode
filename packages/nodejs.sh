#!/bin/bash

# nodejs.sh - Install Node.js and npm on Debian-based systems
# This script installs Node.js and npm using apt

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

# Update package lists
print_info "Updating package lists..."
if ! apt-get update; then
    print_error "Failed to update package lists"
    exit 1
fi

# Install Node.js and npm
print_info "Installing Node.js and npm..."
if apt-get install -y nodejs npm; then
    print_info "Node.js and npm installed successfully!"
else
    print_error "Failed to install Node.js and npm"
    exit 1
fi

# Verify installation
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_info "Node.js version: $NODE_VERSION"
else
    print_warning "Installation completed but 'node' command not found in PATH."
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_info "npm version: $NPM_VERSION"
else
    print_warning "Installation completed but 'npm' command not found in PATH."
fi

print_info "Node.js and npm installation complete!"
