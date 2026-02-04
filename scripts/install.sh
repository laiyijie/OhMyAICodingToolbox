#!/bin/bash
# OhMyAICodingToolbox Install Script (macOS/Linux)
# Usage: ./scripts/install.sh [Tool] [Scope] [Mode] [Lang]
#   Tool: Cursor | Claude | All (default: All)
#   Scope: User | Project (interactive if not provided)
#   Mode: Copy | Link (default: Link)
#   Lang: zh | en (default: en)

set -e

# Default parameters
TOOL="${1:-All}"
SCOPE="${2:-}"
MODE="${3:-Link}"
LANG="${4:-en}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_header() {
    echo -e "\n${MAGENTA}========================================${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${MAGENTA}========================================${NC}\n"
}

# Interactive scope selection if not provided
if [ -z "$SCOPE" ]; then
    echo ""
    print_info "Select installation scope:"
    echo "  [1] User    - Global, available for all projects (~/.cursor/, ~/.claude/)"
    echo "  [2] Project - Current project only (./.cursor/, ./.claude/)"
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
    *)
        print_error "Error: Scope must be 'User' or 'Project'"
        exit 1
        ;;
esac

# Source directories (based on language)
APPLICATION_COMMANDS="$ROOT_DIR/application/$LANG"
TESTING_COMMANDS="$ROOT_DIR/test_project/$LANG"

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

    # Create target directory
    local commands_dir="$target_dir/commands"
    mkdir -p "$commands_dir"
    print_success "  Created directory: $commands_dir"

    # Copy or link application commands
    if [ -d "$APPLICATION_COMMANDS" ]; then
        for file in "$APPLICATION_COMMANDS"/*.md; do
            if [ -f "$file" ]; then
                local filename=$(basename "$file")
                local dest_path="$commands_dir/$filename"

                if [ "$MODE" = "Link" ]; then
                    # Remove existing file/link
                    rm -rf "$dest_path"
                    # Create symbolic link
                    ln -s "$file" "$dest_path"
                    print_success "  Linked: $filename"
                else
                    # Copy file
                    cp "$file" "$dest_path"
                    print_success "  Copied: $filename"
                fi
            fi
        done
    else
        print_warning "  Warning: Source directory not found: $APPLICATION_COMMANDS"
    fi

    # Copy or link testing commands (if exists)
    if [ -d "$TESTING_COMMANDS" ]; then
        for file in "$TESTING_COMMANDS"/*.md; do
            if [ -f "$file" ]; then
                local filename=$(basename "$file")
                local dest_path="$commands_dir/$filename"

                if [ "$MODE" = "Link" ]; then
                    rm -rf "$dest_path"
                    ln -s "$file" "$dest_path"
                    print_success "  Linked: $filename"
                else
                    cp "$file" "$dest_path"
                    print_success "  Copied: $filename"
                fi
            fi
        done
    fi

    print_success "  Done! Installed to: $commands_dir"
}

# Install skills
install_skills() {
    local tool_name=$1
    local target_dir=$2

    print_info "Installing $tool_name skills to $target_dir ..."

    # Create target directory
    local skills_dir="$target_dir/skills"
    mkdir -p "$skills_dir"
    print_success "  Created directory: $skills_dir"

    # TODO: Install skills (none currently)

    print_success "  Done!"
}

# Install tool
install_tool() {
    local tool_name=$1
    local target_dir

    if [ "$tool_name" = "Cursor" ]; then
        target_dir="$CURSOR_DIR"
    else
        target_dir="$CLAUDE_DIR"
    fi

    print_header "Installing $tool_name ($SCOPE level)"

    # Create target root directory
    mkdir -p "$target_dir"
    print_success "Created directory: $target_dir\n"

    # Install commands and skills
    install_commands "$tool_name" "$target_dir"
    install_skills "$tool_name" "$target_dir"
}

# Validate parameters
case "$TOOL" in
    Cursor|Claude|All)
        ;;
    *)
        print_error "Error: Tool must be 'Cursor', 'Claude', or 'All'"
        echo "Usage: $0 [Cursor|Claude|All] [User|Project] [Copy|Link] [zh|en]"
        exit 1
        ;;
esac

case "$MODE" in
    Copy|Link)
        ;;
    *)
        print_error "Error: Mode must be 'Copy' or 'Link'"
        echo "Usage: $0 [Cursor|Claude|All] [User|Project] [Copy|Link] [zh|en]"
        exit 1
        ;;
esac

case "$LANG" in
    zh|en)
        ;;
    *)
        print_error "Error: Language must be 'zh' or 'en'"
        echo "Usage: $0 [Cursor|Claude|All] [User|Project] [Copy|Link] [zh|en]"
        exit 1
        ;;
esac

# Main flow
print_header "OhMyAICodingToolbox Installer"

echo "Configuration:"
echo "  Tool: $TOOL"
echo "  Scope: $SCOPE"
echo "  Mode: $MODE"
echo "  Language: $LANG"
echo ""

# Install based on selection
if [ "$TOOL" = "All" ] || [ "$TOOL" = "Cursor" ]; then
    install_tool "Cursor"
fi

if [ "$TOOL" = "All" ] || [ "$TOOL" = "Claude" ]; then
    install_tool "Claude"
fi

print_header "Installation Complete!"

# Show usage tips
echo -e "${CYAN}Usage Tips:${NC}"
echo -e "  Cursor:   Type oh.specify / oh.plan / oh.implement in chat"
echo -e "  Claude:   Type /oh.specify / /oh.plan / /oh.implement in chat\n"
