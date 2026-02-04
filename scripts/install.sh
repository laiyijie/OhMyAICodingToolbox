#!/bin/bash
# OhMyAICodingToolbox Install Script (macOS/Linux)
# Usage: ./scripts/install.sh [Tool] [Scope] [Lang]
#   Tool: Cursor | Claude (interactive if not provided)
#   Scope: User | Project (interactive if not provided)
#   Lang: zh | en (default: en)

set -e

# Default parameters
TOOL="${1:-}"
SCOPE="${2:-}"
LANG="${3:-en}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Memory path mapping for different tools
get_memory_path() {
    case "$1" in
        Claude) echo "CLAUDE.md" ;;
        Cursor) echo ".cursor/rules/memory.mdc" ;;
    esac
}

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${CYAN}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

print_gray() {
    echo -e "${GRAY}$1${NC}"
}

print_header() {
    echo -e "\n${MAGENTA}========================================${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${MAGENTA}========================================${NC}\n"
}

# Interactive tool selection if not provided
if [ -z "$TOOL" ]; then
    echo ""
    print_info "Select AI coding tool:"
    echo "  [1] Claude Code"
    echo "  [2] Cursor"
    echo ""

    read -p "Enter choice (1 or 2): " choice

    case "$choice" in
        1) TOOL="Claude" ;;
        2) TOOL="Cursor" ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
    echo ""
fi

# Validate tool
case "$TOOL" in
    Cursor|Claude)
        ;;
    *)
        print_error "Error: Tool must be 'Cursor' or 'Claude'"
        echo "Usage: $0 [Cursor|Claude] [User|Project] [zh|en]"
        exit 1
        ;;
esac

# Interactive scope selection if not provided
if [ -z "$SCOPE" ]; then
    print_info "Select installation scope:"
    echo "  [1] User    - Global, available for all projects"
    echo "  [2] Project - Current project only"
    echo ""

    read -p "Enter choice (1 or 2): " choice

    case "$choice" in
        1) SCOPE="User" ;;
        2) SCOPE="Project" ;;
        *)
            print_warning "Invalid choice. Using default: User"
            SCOPE="User"
            ;;
    esac
    echo ""
fi

# Validate scope
case "$SCOPE" in
    User|Project)
        ;;
    *)
        print_error "Error: Scope must be 'User' or 'Project'"
        echo "Usage: $0 [Cursor|Claude] [User|Project] [zh|en]"
        exit 1
        ;;
esac

# Validate language
case "$LANG" in
    zh|en)
        ;;
    *)
        print_error "Error: Language must be 'zh' or 'en'"
        echo "Usage: $0 [Cursor|Claude] [User|Project] [zh|en]"
        exit 1
        ;;
esac

# Define tool directories
case "$SCOPE" in
    User)
        CURSOR_DIR="$HOME/.cursor"
        CLAUDE_DIR="$HOME/.claude"
        ;;
    Project)
        CURSOR_DIR="$(pwd)/.cursor"
        CLAUDE_DIR="$(pwd)/.claude"
        ;;
esac

# Get target directory based on tool
if [ "$TOOL" = "Cursor" ]; then
    TARGET_DIR="$CURSOR_DIR"
else
    TARGET_DIR="$CLAUDE_DIR"
fi

# Source directories (based on language)
APPLICATION_COMMANDS="$ROOT_DIR/application/$LANG"
TESTING_COMMANDS="$ROOT_DIR/test_project/$LANG"

# Get memory path for the selected tool
MEMORY_PATH=$(get_memory_path "$TOOL")

# Install commands
install_commands() {
    local tool_name=$1
    local target_dir=$2

    local lang_label
    if [ "$LANG" = "zh" ]; then
        lang_label="Chinese"
    else
        lang_label="English"
    fi

    print_info "Installing $tool_name commands ($lang_label) to $target_dir ..."
    print_gray "  Memory path: $MEMORY_PATH"

    # Create target directory
    local commands_dir="$target_dir/commands"
    mkdir -p "$commands_dir"
    print_success "  Created directory: $commands_dir"

    # Copy and process application commands
    if [ -d "$APPLICATION_COMMANDS" ]; then
        for file in "$APPLICATION_COMMANDS"/*.md; do
            if [ -f "$file" ]; then
                local filename=$(basename "$file")
                local dest_path="$commands_dir/$filename"

                # Read content, replace placeholder, and write to destination
                sed "s|{{MEMORY_PATH}}|$MEMORY_PATH|g" "$file" > "$dest_path"
                print_success "  Installed: $filename"
            fi
        done
    else
        print_warning "  Warning: Source directory not found: $APPLICATION_COMMANDS"
    fi

    # Copy and process testing commands (if exists)
    if [ -d "$TESTING_COMMANDS" ]; then
        for file in "$TESTING_COMMANDS"/*.md; do
            if [ -f "$file" ]; then
                local filename=$(basename "$file")
                local dest_path="$commands_dir/$filename"

                sed "s|{{MEMORY_PATH}}|$MEMORY_PATH|g" "$file" > "$dest_path"
                print_success "  Installed: $filename"
            fi
        done
    fi

    print_success "  Done! Installed to: $commands_dir"
}

# Main flow
print_header "OhMyAICodingToolbox Installer"

echo "Configuration:"
echo "  Tool: $TOOL"
echo "  Scope: $SCOPE"
echo "  Language: $LANG"
echo "  Memory Path: $MEMORY_PATH"
echo ""

print_header "Installing for $TOOL ($SCOPE level)"

# Create target root directory
mkdir -p "$TARGET_DIR"
print_success "Created directory: $TARGET_DIR\n"

# Install commands
install_commands "$TOOL" "$TARGET_DIR"

print_header "Installation Complete!"

# Show usage tips
echo -e "${CYAN}Usage Tips:${NC}"
if [ "$TOOL" = "Cursor" ]; then
    echo -e "  In Cursor chat, type: oh.specify / oh.plan / oh.implement"
else
    echo -e "  In Claude Code, type: /oh.specify / /oh.plan / /oh.implement"
fi
echo ""
