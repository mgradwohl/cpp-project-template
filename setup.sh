#!/usr/bin/env bash
#
# Project Setup Script
# Renames placeholder "MyProject" to your project name throughout the codebase.
#
# Usage: ./setup.sh --name "YourProjectName" [--author "Your Name"]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Defaults
PROJECT_NAME=""
AUTHOR_NAME=""
VERBOSE=false

usage() {
    cat <<EOF
Usage: $(basename "$0") --name "YourProjectName" [OPTIONS]

Rename this template project to your chosen name.

Required:
  --name, -n NAME     Your project name (e.g., "AwesomeApp")

Optional:
  --author, -a NAME   Author name for documentation
  --verbose, -v       Show detailed progress
  --help, -h          Show this help

Examples:
  $(basename "$0") --name "MyCoolProject"
  $(basename "$0") -n "DataProcessor" -a "Jane Doe" -v

Note: This script will:
  - Rename MyProject -> YourProjectName in all files
  - Rename MYPROJECT -> YOURPROJECTNAME (uppercase)
  - Rename myproject -> yourprojectname (lowercase)
  - Update CMakeLists.txt, VS Code configs, and documentation
  - Delete itself and setup.ps1 after completion
EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        -a|--author)
            AUTHOR_NAME="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown argument: $1" >&2
            usage
            ;;
    esac
done

# Validate
if [[ -z "$PROJECT_NAME" ]]; then
    echo "Error: --name is required" >&2
    usage
fi

# Derive variants
PROJECT_UPPER=$(echo "$PROJECT_NAME" | tr '[:lower:]' '[:upper:]')
PROJECT_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')

echo "Setting up project: $PROJECT_NAME"
echo "  Uppercase: $PROJECT_UPPER"
echo "  Lowercase: $PROJECT_LOWER"
[[ -n "$AUTHOR_NAME" ]] && echo "  Author: $AUTHOR_NAME"
echo ""

# Files to process (excluding .git, build, and this script)
find_files() {
    find "$SCRIPT_DIR" -type f \
        ! -path "*/.git/*" \
        ! -path "*/build/*" \
        ! -name "setup.sh" \
        ! -name "setup.ps1" \
        -print0
}

# Count replacements
COUNT=0

while IFS= read -r -d '' file; do
    # Skip binary files
    if file "$file" | grep -q "text"; then
        MODIFIED=false
        
        # Replace MyProject -> ProjectName
        if grep -q "MyProject" "$file" 2>/dev/null; then
            sed -i "s/MyProject/$PROJECT_NAME/g" "$file"
            MODIFIED=true
        fi
        
        # Replace MYPROJECT -> PROJECTNAME
        if grep -q "MYPROJECT" "$file" 2>/dev/null; then
            sed -i "s/MYPROJECT/$PROJECT_UPPER/g" "$file"
            MODIFIED=true
        fi
        
        # Replace myproject -> projectname
        if grep -q "myproject" "$file" 2>/dev/null; then
            sed -i "s/myproject/$PROJECT_LOWER/g" "$file"
            MODIFIED=true
        fi
        
        # Update author if provided
        if [[ -n "$AUTHOR_NAME" ]] && grep -q "Your Name" "$file" 2>/dev/null; then
            sed -i "s/Your Name/$AUTHOR_NAME/g" "$file"
            MODIFIED=true
        fi
        
        if $MODIFIED; then
            COUNT=$((COUNT + 1))
            if $VERBOSE; then
                echo "  Updated: ${file#$SCRIPT_DIR/}"
            fi
        fi
    fi
done < <(find_files)

echo ""
echo "Updated $COUNT files."

# Clean up setup scripts
echo "Removing setup scripts..."
rm -f "$SCRIPT_DIR/setup.sh" "$SCRIPT_DIR/setup.ps1"

echo ""
echo "Setup complete! Your project '$PROJECT_NAME' is ready."
echo ""
echo "Next steps:"
echo "  1. Review the changes: git diff"
echo "  2. Build the project: cmake --preset debug && cmake --build --preset debug"
echo "  3. Run tests: ctest --preset debug"
echo "  4. Commit: git add -A && git commit -m 'Initial project setup'"
echo "  4. Commit: git add -A && git commit -m 'Initial project setup'"
