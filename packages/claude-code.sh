#!/bin/bash

# claude-code.sh - Install Claude Code CLI
# This script installs the Claude Code CLI using npm

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

# Check if npm is available
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install Node.js and npm first."
    exit 1
fi

print_info "Installing Claude Code CLI..."

# Install Claude Code CLI globally using npm
if npm install -g @anthropic-ai/claude-code; then
    print_info "Claude Code CLI installed successfully!"
else
    print_error "Failed to install Claude Code CLI"
    exit 1
fi

# Verify installation
if command -v claude &> /dev/null; then
    print_info "Claude Code CLI is now available. Run 'claude' to get started."
else
    print_warning "Installation completed but 'claude' command not found in PATH."
    print_info "You may need to restart your terminal or add npm global bin to your PATH."
fi

# Create claude-wrapper in /usr/local/bin
print_info "Creating claude-wrapper..."
WRAPPER_PATH="/bin/claude-wrapper"

cat > "$WRAPPER_PATH" << 'EOF'
#!/bin/bash
# Take all arguments except the first (the original binary name)
shift
# Execute your desired binary instead, with all remaining args
exec claude "$@"
EOF

# Make the wrapper script executable
if chmod +x "$WRAPPER_PATH"; then
    print_info "claude-wrapper created and made executable at $WRAPPER_PATH"
else
    print_error "Failed to make claude-wrapper.sh executable"
    exit 1
fi

print_info "Claude Code CLI installation complete!"
