#!/bin/bash
# setup-beads.sh
# Installs and configures Beads (bd) task tracking tool

set -e

echo "=== Beads Setup ==="
echo ""

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Error: Go is required but not installed."
    echo "Install Go from: https://go.dev/doc/install"
    echo ""
    echo "Or install via Homebrew (macOS):"
    echo "  brew install go"
    exit 1
fi

# Install beads
echo "Installing beads via go install..."
go install github.com/steveyegge/beads/cmd/bd@latest

# Verify installation
if ! command -v bd &> /dev/null; then
    echo ""
    echo "Installation completed but bd not found in PATH."
    echo "Add Go bin to your PATH:"
    echo "  export PATH="\$PATH:\$(go env GOPATH)/bin""
    echo ""
    echo "Add this to your ~/.bashrc or ~/.zshrc"
    exit 1
fi

echo ""
echo "Beads installed successfully!"
echo ""

# Ask about initialization
read -p "Initialize Beads in current directory? (y/n) " -n 1 -r
echo
if [[ \$REPLY =~ ^[Yy]\$ ]]; then
    bd init
    echo ""
    echo "Beads initialized!"
fi

# Ask about editor integration
echo ""
echo "Editor Integration (optional):"
echo "1. Claude Code"
echo "2. Cursor"
echo "3. Aider"
echo "4. Skip"
echo ""
read -p "Select editor (1-4): " -n 1 -r editor_choice
echo

case \$editor_choice in
    1)
        bd setup claude
        echo "Claude Code integration configured!"
        ;;
    2)
        bd setup cursor
        echo "Cursor integration configured!"
        ;;
    3)
        bd setup aider
        echo "Aider integration configured!"
        ;;
    *)
        echo "Skipping editor integration."
        ;;
esac

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Quick Start:"
echo "  bd ready --json       # Find unblocked work"
echo "  bd create "Task"     # Create an issue"
echo "  bd doctor             # Run daily for maintenance"
echo "  bd cleanup            # Clean old issues"
echo ""
echo "Best Practices (from Steve Yegge):"
echo "  - File beads for anything taking > 2 minutes"
echo "  - Run bd doctor daily"
echo "  - Run bd cleanup when issues exceed ~200"
echo "  - Use hierarchical structure for epics/tasks"
echo ""
echo "Documentation: https://github.com/steveyegge/beads"
