#!/bin/bash
# Quick script to build remaining frameworks

set -e

BUILD_DIR="$(pwd)/build"
mkdir -p "$BUILD_DIR/checksums"

echo "Building JWTDecode..."
cd "$BUILD_DIR/temp/JWTDecode" 2>/dev/null || (cd "$BUILD_DIR/temp" && git clone --branch 3.2.0 --depth 1 https://github.com/auth0/JWTDecode.swift.git JWTDecode && cd JWTDecode)

xcodebuild archive -scheme "JWTDecode-iOS" -destination "generic/platform=iOS" -archivePath "$BUILD_DIR/JWTDecode-ios.xcarchive" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
xcodebuild archive -scheme "JWTDecode-iOS" -destination "generic/platform=iOS Simulator" -archivePath "$BUILD_DIR/JWTDecode-sim.xcarchive" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

cd $(pwd)
rm -rf JWTDecode.xcframework
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/JWTDecode-ios.xcarchive/Products/Library/Frameworks/JWTDecode.framework" \
  -framework "$BUILD_DIR/JWTDecode-sim.xcarchive/Products/Library/Frameworks/JWTDecode.framework" \
  -output "JWTDecode.xcframework"

rm -f JWTDecode.xcframework.zip
ditto -c -k --sequesterRsrc --keepParent JWTDecode.xcframework JWTDecode.xcframework.zip
swift package compute-checksum JWTDecode.xcframework.zip

echo "✓ JWTDecode complete!"
