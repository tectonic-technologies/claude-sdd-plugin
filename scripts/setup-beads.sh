#!/bin/bash
# setup-beads.sh
# Installs Beads (bd) task tracking tool

set -e

echo "Installing Beads (bd) task tracking tool..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Error: Go is required but not installed."
    echo "Install Go from: https://go.dev/doc/install"
    exit 1
fi

# Install beads
echo "Installing beads via go install..."
go install github.com/steveyegge/beads/cmd/bd@latest

# Verify installation
if command -v bd &> /dev/null; then
    echo ""
    echo "✅ Beads installed successfully!"
    echo ""
    echo "Quick start:"
    echo "  cd your-project"
    echo "  bd init              # Initialize in project root"
    echo "  bd create "Task"    # Create an issue"
    echo "  bd ready --json      # Find unblocked work"
    echo "  bd list              # List all issues"
    echo ""
    echo "Documentation: https://github.com/steveyegge/beads"
else
    echo ""
    echo "⚠️  Installation completed but bd not found in PATH."
    echo "Add Go bin to your PATH:"
    echo "  export PATH="\$PATH:\$(go env GOPATH)/bin""
fi
