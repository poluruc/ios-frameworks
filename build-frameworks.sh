#!/bin/bash

# iOS Frameworks Builder for SDK 26.1.1 (Xcode 16.1)
# This script clones, builds, and packages all iOS frameworks with the latest SDK

set -e  # Exit on any error

# Configuration
XCODE_VERSION="16.1"
SDK_VERSION="26.1.1"
IOS_DEPLOYMENT_TARGET="16.0"
BUILD_DIR="$(pwd)/build"
OUTPUT_DIR="$(pwd)"
TEMP_DIR="$BUILD_DIR/temp"

# Framework versions - update these to desired versions
ALAMOFIRE_VERSION="5.9.1"
REALM_VERSION="v10.54.0"
KINGFISHER_VERSION="8.1.1"
DGCHARTS_VERSION="5.1.0"
JWTDECODE_VERSION="3.2.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $1"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Verify Xcode installation
verify_xcode() {
    print_header "Verifying Xcode Installation"
    
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode is not installed or xcodebuild is not in PATH"
        exit 1
    fi
    
    CURRENT_XCODE_VERSION=$(xcodebuild -version | head -n 1 | awk '{print $2}')
    print_status "Current Xcode version: $CURRENT_XCODE_VERSION"
    
    SDK_VERSION_ACTUAL=$(xcodebuild -showsdks | grep iphoneos | tail -n 1 | awk '{print $NF}' | sed 's/iphoneos//')
    print_status "Current iOS SDK version: $SDK_VERSION_ACTUAL"
    
    if [[ "$CURRENT_XCODE_VERSION" < "16.1" ]]; then
        print_warning "Xcode 16.1 or later is recommended for SDK 26.1.1"
    else
        print_success "Xcode version is compatible"
    fi
}

# Create build directories
setup_directories() {
    print_header "Setting Up Build Environment"
    
    print_status "Creating build directories..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    mkdir -p "$TEMP_DIR"
    
    print_success "Build directories created"
}

# Generic function to build XCFramework
build_xcframework() {
    local FRAMEWORK_NAME=$1
    local REPO_URL=$2
    local VERSION=$3
    local SCHEME=$4
    local WORKSPACE=$5
    
    print_header "Building $FRAMEWORK_NAME $VERSION"
    
    local FRAMEWORK_DIR="$TEMP_DIR/$FRAMEWORK_NAME"
    local ARCHIVE_DIR="$BUILD_DIR/archives/$FRAMEWORK_NAME"
    
    # Clone repository
    print_status "Cloning $FRAMEWORK_NAME from GitHub..."
    cd "$TEMP_DIR"
    git clone --branch "$VERSION" --depth 1 "$REPO_URL" "$FRAMEWORK_NAME" || {
        print_error "Failed to clone $FRAMEWORK_NAME"
        return 1
    }
    cd "$FRAMEWORK_NAME"
    
    print_success "Repository cloned"
    
    # Create archive directories
    mkdir -p "$ARCHIVE_DIR"
    
    # Build for iOS device (arm64)
    print_status "Building for iOS device (arm64)..."
    
    # Check if xcpretty is available
    if command -v xcpretty &> /dev/null; then
        XCPRETTY_CMD="| xcpretty"
    else
        XCPRETTY_CMD=""
    fi
    
    if [ -n "$WORKSPACE" ]; then
        xcodebuild archive \
            -workspace "$WORKSPACE" \
            -scheme "$SCHEME" \
            -destination "generic/platform=iOS" \
            -archivePath "$ARCHIVE_DIR/ios.xcarchive" \
            SKIP_INSTALL=NO \
            BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
            IPHONEOS_DEPLOYMENT_TARGET="$IOS_DEPLOYMENT_TARGET" \
            ONLY_ACTIVE_ARCH=NO \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO
    else
        xcodebuild archive \
            -scheme "$SCHEME" \
            -destination "generic/platform=iOS" \
            -archivePath "$ARCHIVE_DIR/ios.xcarchive" \
            SKIP_INSTALL=NO \
            BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
            IPHONEOS_DEPLOYMENT_TARGET="$IOS_DEPLOYMENT_TARGET" \
            ONLY_ACTIVE_ARCH=NO \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO
    fi
    
    print_success "iOS device archive complete"
    
    # Build for iOS Simulator (arm64 + x86_64)
    print_status "Building for iOS Simulator (arm64 + x86_64)..."
    
    if [ -n "$WORKSPACE" ]; then
        xcodebuild archive \
            -workspace "$WORKSPACE" \
            -scheme "$SCHEME" \
            -destination "generic/platform=iOS Simulator" \
            -archivePath "$ARCHIVE_DIR/ios-simulator.xcarchive" \
            SKIP_INSTALL=NO \
            BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
            IPHONEOS_DEPLOYMENT_TARGET="$IOS_DEPLOYMENT_TARGET" \
            ONLY_ACTIVE_ARCH=NO \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO
    else
        xcodebuild archive \
            -scheme "$SCHEME" \
            -destination "generic/platform=iOS Simulator" \
            -archivePath "$ARCHIVE_DIR/ios-simulator.xcarchive" \
            SKIP_INSTALL=NO \
            BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
            IPHONEOS_DEPLOYMENT_TARGET="$IOS_DEPLOYMENT_TARGET" \
            ONLY_ACTIVE_ARCH=NO \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO
    fi
    
    print_success "iOS Simulator archive complete"
    
    # Find framework paths
    IOS_FRAMEWORK=$(find "$ARCHIVE_DIR/ios.xcarchive/Products" -name "$FRAMEWORK_NAME.framework" | head -n 1)
    SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/ios-simulator.xcarchive/Products" -name "$FRAMEWORK_NAME.framework" | head -n 1)
    
    if [ -z "$IOS_FRAMEWORK" ] || [ -z "$SIM_FRAMEWORK" ]; then
        print_error "Failed to find framework archives"
        return 1
    fi
    
    # Create XCFramework
    print_status "Creating XCFramework..."
    
    rm -rf "$OUTPUT_DIR/$FRAMEWORK_NAME.xcframework"
    
    xcodebuild -create-xcframework \
        -framework "$IOS_FRAMEWORK" \
        -framework "$SIM_FRAMEWORK" \
        -output "$OUTPUT_DIR/$FRAMEWORK_NAME.xcframework"
    
    print_success "$FRAMEWORK_NAME.xcframework created successfully"
    
    # Create zip archive
    print_status "Creating ZIP archive..."
    cd "$OUTPUT_DIR"
    rm -f "$FRAMEWORK_NAME.xcframework.zip"
    ditto -c -k --sequesterRsrc --keepParent "$FRAMEWORK_NAME.xcframework" "$FRAMEWORK_NAME.xcframework.zip"
    
    local ZIP_SIZE=$(du -h "$FRAMEWORK_NAME.xcframework.zip" | cut -f1)
    print_success "$FRAMEWORK_NAME.xcframework.zip created ($ZIP_SIZE)"
    
    # Calculate checksum
    local CHECKSUM=$(swift package compute-checksum "$FRAMEWORK_NAME.xcframework.zip")
    print_success "Checksum: $CHECKSUM"
    
    # Store checksum for later
    echo "$FRAMEWORK_NAME=$CHECKSUM" >> "$BUILD_DIR/checksums.txt"
}

# Build Alamofire
build_alamofire() {
    build_xcframework \
        "Alamofire" \
        "https://github.com/Alamofire/Alamofire.git" \
        "$ALAMOFIRE_VERSION" \
        "Alamofire iOS" \
        ""
}

# Build Realm
build_realm() {
    print_header "Building Realm $REALM_VERSION"
    
    local FRAMEWORK_DIR="$TEMP_DIR/realm-swift"
    
    # Clone repository
    print_status "Cloning Realm from GitHub..."
    cd "$TEMP_DIR"
    git clone --branch "$REALM_VERSION" --depth 1 "https://github.com/realm/realm-swift.git" || {
        print_error "Failed to clone Realm"
        return 1
    }
    cd realm-swift
    
    print_success "Repository cloned"
    
    # Get Xcode version for SWIFT_VERSION and deployment target configuration
    local XCODE_VERSION_MAJOR=$(xcodebuild -version | head -n 1 | awk '{print $2}' | sed 's/\.//' | cut -c1-4)
    print_status "Detected Xcode version major: $XCODE_VERSION_MAJOR"
    
    # Configure SWIFT_VERSION and IPHONEOS_DEPLOYMENT_TARGET in Realm's Base.xcconfig
    print_status "Configuring build settings for Realm..."
    local CONFIG_FILE="Configuration/Base.xcconfig"
    
    # Add IPHONEOS_DEPLOYMENT_TARGET for current Xcode version if not present
    if ! grep -q "IPHONEOS_DEPLOYMENT_TARGET_${XCODE_VERSION_MAJOR}" "$CONFIG_FILE"; then
        print_status "Adding IPHONEOS_DEPLOYMENT_TARGET_${XCODE_VERSION_MAJOR} = $IOS_DEPLOYMENT_TARGET to $CONFIG_FILE"
        # Insert after IPHONEOS_DEPLOYMENT_TARGET_1600 line
        sed -i.bak "/^IPHONEOS_DEPLOYMENT_TARGET_1600/a\\
IPHONEOS_DEPLOYMENT_TARGET_${XCODE_VERSION_MAJOR} = $IOS_DEPLOYMENT_TARGET;\\
" "$CONFIG_FILE"
    fi
    
    # Add SWIFT_VERSION for current Xcode version if not present
    if ! grep -q "SWIFT_VERSION_${XCODE_VERSION_MAJOR}" "$CONFIG_FILE"; then
        print_status "Adding SWIFT_VERSION_${XCODE_VERSION_MAJOR} = 6.0 to $CONFIG_FILE"
        # Insert after SWIFT_VERSION_1600 line
        sed -i.bak2 "/^SWIFT_VERSION_1600/a\\
SWIFT_VERSION_${XCODE_VERSION_MAJOR} = 6.0;\\
" "$CONFIG_FILE"
    fi
    
    # Change SWIFT_VERSION_1600 from 5.7 to 6.0
    sed -i.bak3 "s/^SWIFT_VERSION_1600 = 5.7;/SWIFT_VERSION_1600 = 6.0;/" "$CONFIG_FILE"
    
    # Add fallback SWIFT_VERSION if not present
    if ! grep -q "^SWIFT_VERSION = " "$CONFIG_FILE"; then
        echo "SWIFT_VERSION = 6.0;" >> "$CONFIG_FILE"
        print_status "Added fallback SWIFT_VERSION = 6.0"
    fi
    
    print_success "Build settings configured for Xcode $XCODE_VERSION_MAJOR (iOS $IOS_DEPLOYMENT_TARGET, Swift 6.0)"
    
    # Realm uses its own build system
    print_status "Building Realm using build.sh..."
    
    # Build Realm
    ./build.sh xcframework
    
    # Fix MinimumOSVersion in built frameworks
    print_status "Fixing MinimumOSVersion to $IOS_DEPLOYMENT_TARGET..."
    for plist in build/Release/ios/Realm.xcframework/*/Realm.framework/Info.plist build/Release/ios/RealmSwift.xcframework/*/RealmSwift.framework/Info.plist; do
        if [ -f "$plist" ]; then
            /usr/libexec/PlistBuddy -c "Set :MinimumOSVersion $IOS_DEPLOYMENT_TARGET" "$plist" 2>/dev/null || 
                /usr/libexec/PlistBuddy -c "Add :MinimumOSVersion string $IOS_DEPLOYMENT_TARGET" "$plist"
        fi
    done
    print_success "MinimumOSVersion set to $IOS_DEPLOYMENT_TARGET"
    
    # Copy built frameworks to output directory
    print_status "Copying Realm frameworks..."
    
    cp -R build/Release/ios/Realm.xcframework "$OUTPUT_DIR/"
    cp -R build/Release/ios/RealmSwift.xcframework "$OUTPUT_DIR/"
    
    print_success "Realm frameworks copied"
    
    # Create zip archives
    cd "$OUTPUT_DIR"
    
    print_status "Creating Realm ZIP archive..."
    rm -f "Realm.xcframework.zip"
    ditto -c -k --sequesterRsrc --keepParent "Realm.xcframework" "Realm.xcframework.zip"
    local REALM_CHECKSUM=$(swift package compute-checksum "Realm.xcframework.zip")
    echo "Realm=$REALM_CHECKSUM" >> "$BUILD_DIR/checksums.txt"
    print_success "Realm.xcframework.zip created"
    print_success "Checksum: $REALM_CHECKSUM"
    
    print_status "Creating RealmSwift ZIP archive..."
    rm -f "RealmSwift.xcframework.zip"
    ditto -c -k --sequesterRsrc --keepParent "RealmSwift.xcframework" "RealmSwift.xcframework.zip"
    local REALMSWIFT_CHECKSUM=$(swift package compute-checksum "RealmSwift.xcframework.zip")
    echo "RealmSwift=$REALMSWIFT_CHECKSUM" >> "$BUILD_DIR/checksums.txt"
    print_success "RealmSwift.xcframework.zip created"
    print_success "Checksum: $REALMSWIFT_CHECKSUM"
}

# Build Kingfisher
build_kingfisher() {
    build_xcframework \
        "Kingfisher" \
        "https://github.com/onevcat/Kingfisher.git" \
        "$KINGFISHER_VERSION" \
        "Kingfisher-iOS" \
        ""
}

# Build DGCharts
build_dgcharts() {
    build_xcframework \
        "DGCharts" \
        "https://github.com/danielgindi/Charts.git" \
        "$DGCHARTS_VERSION" \
        "DGCharts" \
        ""
}

# Build JWTDecode
build_jwtdecode() {
    build_xcframework \
        "JWTDecode" \
        "https://github.com/auth0/JWTDecode.swift.git" \
        "$JWTDECODE_VERSION" \
        "JWTDecode-iOS" \
        ""
}

# Generate updated Package.swift with new checksums
generate_package_swift() {
    print_header "Generating Updated Package.swift"
    
    if [ ! -f "$BUILD_DIR/checksums.txt" ]; then
        print_warning "Checksums file not found, skipping Package.swift generation"
        return
    fi
    
    # Read checksums
    source "$BUILD_DIR/checksums.txt" 2>/dev/null || true
    
    cat > "$OUTPUT_DIR/Package.swift" << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ios-frameworks",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Alamofire", targets: ["Alamofire"]),
        .library(name: "JWTDecode", targets: ["JWTDecode"]),
        .library(name: "Kingfisher", targets: ["Kingfisher"]),
        .library(name: "Realm", targets: ["Realm"]),
        .library(name: "RealmSwift", targets: ["RealmSwift"]),
        .library(name: "DGCharts", targets: ["DGCharts"])
    ],
    targets: [
        .binaryTarget(
            name: "Alamofire",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Alamofire.xcframework.zip",
            checksum: "$(grep 'Alamofire=' $BUILD_DIR/checksums.txt | cut -d= -f2)"
        ),
        .binaryTarget(
            name: "JWTDecode",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/JWTDecode.xcframework.zip",
            checksum: "$(grep 'JWTDecode=' $BUILD_DIR/checksums.txt | cut -d= -f2)"
        ),
        .binaryTarget(
            name: "Kingfisher",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Kingfisher.xcframework.zip",
            checksum: "$(grep 'Kingfisher=' $BUILD_DIR/checksums.txt | cut -d= -f2)"
        ),
        .binaryTarget(
            name: "Realm",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Realm.xcframework.zip",
            checksum: "$(grep 'Realm=' $BUILD_DIR/checksums.txt | cut -d= -f2)"
        ),
        .binaryTarget(
            name: "RealmSwift",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/RealmSwift.xcframework.zip",
            checksum: "$(grep 'RealmSwift=' $BUILD_DIR/checksums.txt | cut -d= -f2)"
        ),
        .binaryTarget(
            name: "DGCharts",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/DGCharts.xcframework.zip",
            checksum: "$(grep 'DGCharts=' $BUILD_DIR/checksums.txt | cut -d= -f2)"
        )
    ]
)
EOF
    
    print_success "Package.swift generated with updated checksums"
}

# Display build summary
display_summary() {
    print_header "Build Summary"
    
    echo ""
    echo "Built Frameworks:"
    echo "================="
    
    for framework in Alamofire JWTDecode Kingfisher Realm RealmSwift DGCharts; do
        if [ -d "$OUTPUT_DIR/$framework.xcframework" ]; then
            local SIZE=$(du -sh "$OUTPUT_DIR/$framework.xcframework" | cut -f1)
            local ZIP_SIZE=$(du -sh "$OUTPUT_DIR/$framework.xcframework.zip" 2>/dev/null | cut -f1 || echo "N/A")
            echo -e "${GREEN}✓${NC} $framework.xcframework ($SIZE) | ZIP: $ZIP_SIZE"
        else
            echo -e "${RED}✗${NC} $framework.xcframework - NOT FOUND"
        fi
    done
    
    echo ""
    echo "Checksums:"
    echo "=========="
    if [ -f "$BUILD_DIR/checksums.txt" ]; then
        cat "$BUILD_DIR/checksums.txt"
    else
        echo "No checksums available"
    fi
    
    echo ""
    print_success "All frameworks built with SDK $SDK_VERSION_ACTUAL"
    print_success "Deployment target: iOS $IOS_DEPLOYMENT_TARGET"
    print_success "Build artifacts located in: $OUTPUT_DIR"
}

# Main build process
main() {
    print_header "iOS Frameworks Builder - SDK 26.1.1"
    
    echo "This script will build the following frameworks:"
    echo "  • Alamofire $ALAMOFIRE_VERSION"
    echo "  • Realm $REALM_VERSION"
    echo "  • Kingfisher $KINGFISHER_VERSION"
    echo "  • DGCharts $DGCHARTS_VERSION"
    echo "  • JWTDecode $JWTDECODE_VERSION"
    echo ""
    echo "Build configuration:"
    echo "  • Deployment Target: iOS $IOS_DEPLOYMENT_TARGET"
    echo "  • Output Directory: $OUTPUT_DIR"
    echo ""
    
    read -p "Continue with build? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Build cancelled by user"
        exit 0
    fi
    
    verify_xcode
    setup_directories
    
    # Check if xcpretty is available for cleaner output
    if ! command -v xcpretty &> /dev/null; then
        print_warning "xcpretty not installed - build output will be verbose"
        print_status "Install with: gem install xcpretty"
    fi
    
    # Build each framework
    build_alamofire
    build_jwtdecode
    build_kingfisher
    build_dgcharts
    build_realm
    
    # Generate Package.swift
    generate_package_swift
    
    # Display summary
    display_summary
    
    print_header "Build Complete! 🎉"
    
    echo "Next steps:"
    echo "1. Review the built frameworks in the current directory"
    echo "2. Test the frameworks in a sample project"
    echo "3. Update CHANGELOG.md with new versions and SDK compatibility"
    echo "4. Commit and push to repository"
    echo ""
}

# Run main function
main
