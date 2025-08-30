#!/bin/bash

# iOS Frameworks Repository Setup Script
# This script helps initialize Git LFS and verify framework repository setup

set -e  # Exit on any error

echo "🚀 iOS Frameworks Repository Setup"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi

print_success "Git is installed"

# Check if Git LFS is installed
if ! command -v git-lfs &> /dev/null; then
    print_warning "Git LFS is not installed."
    echo ""
    echo "To install Git LFS:"
    echo "  macOS (Homebrew): brew install git-lfs"
    echo "  Other platforms: https://git-lfs.github.io/"
    echo ""
    read -p "Continue without Git LFS? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    SKIP_LFS=true
else
    print_success "Git LFS is installed"
    SKIP_LFS=false
fi

# Initialize Git repository if not already initialized
if [ ! -d ".git" ]; then
    print_status "Initializing Git repository..."
    git init
    print_success "Git repository initialized"
else
    print_success "Git repository already exists"
fi

# Install Git LFS hooks if not skipping LFS
if [ "$SKIP_LFS" = false ]; then
    print_status "Installing Git LFS hooks..."
    git lfs install
    print_success "Git LFS hooks installed"
    
    # Track large files with LFS
    print_status "Configuring Git LFS tracking..."
    if [ -f ".gitattributes" ]; then
        print_success "Git LFS tracking already configured (.gitattributes exists)"
    else
        print_warning ".gitattributes file not found. Creating basic LFS configuration..."
        cat > .gitattributes << EOF
# Basic Git LFS configuration for iOS frameworks
*.xcframework/** filter=lfs diff=lfs merge=lfs -text
*.framework/** filter=lfs diff=lfs merge=lfs -text
*.a filter=lfs diff=lfs merge=lfs -text
*.dylib filter=lfs diff=lfs merge=lfs -text
EOF
        print_success "Basic .gitattributes created"
    fi
fi

# Verify framework structure
print_status "Verifying framework structure..."

FRAMEWORK_COUNT=0
for framework in *.xcframework; do
    if [ -d "$framework" ]; then
        print_success "Found framework: $framework"
        FRAMEWORK_COUNT=$((FRAMEWORK_COUNT + 1))
    fi
done

if [ $FRAMEWORK_COUNT -eq 0 ]; then
    print_warning "No .xcframework directories found in current directory"
    echo "Make sure you're running this script in the frameworks repository root."
else
    print_success "Found $FRAMEWORK_COUNT framework(s)"
fi

# Check for required files
print_status "Checking repository files..."

required_files=("README.md" ".gitignore")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_success "$file exists"
    else
        print_warning "$file not found"
    fi
done

# Display framework sizes
if [ $FRAMEWORK_COUNT -gt 0 ]; then
    echo ""
    print_status "Framework sizes:"
    for framework in *.xcframework; do
        if [ -d "$framework" ]; then
            size=$(du -sh "$framework" | cut -f1)
            echo "  $framework: $size"
        fi
    done
fi

# Check if frameworks are already tracked
if [ "$SKIP_LFS" = false ] && [ $FRAMEWORK_COUNT -gt 0 ]; then
    echo ""
    print_status "Checking Git LFS tracking status..."
    
    lfs_files=$(git lfs ls-files 2>/dev/null | wc -l)
    if [ $lfs_files -gt 0 ]; then
        print_success "$lfs_files file(s) tracked by Git LFS"
    else
        print_warning "No files currently tracked by Git LFS"
        echo "You may need to add and commit your frameworks:"
        echo "  git add *.xcframework"
        echo "  git commit -m 'Add prebuilt iOS frameworks'"
    fi
fi

# Final recommendations
echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "Next steps:"
echo ""
echo "1. 📝 Review and update README.md with your specific details"
echo "2. 🔧 Verify framework versions in CHANGELOG.md"
echo "3. 📦 Add frameworks to Git (if not already done):"
echo "   git add ."
echo "   git commit -m 'Initial commit: iOS prebuilt frameworks'"
echo ""
echo "4. 🚀 Push to remote repository:"
echo "   git remote add origin <your-repository-url>"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""

if [ "$SKIP_LFS" = false ]; then
    echo "5. 💡 For collaborators, they should run:"
    echo "   git lfs pull"
    echo "   after cloning the repository"
    echo ""
fi

echo "6. 📚 Share integration instructions from README.md with your team"
echo ""

print_success "Repository setup complete! 🎉"