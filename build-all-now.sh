#!/bin/bash
# Build all frameworks with SDK 26.1.1

set -e

OUTPUT_DIR="/Users/poluruc/personal/projects/ios-frameworks"
BUILD_DIR="$OUTPUT_DIR/build"
TEMP_DIR="$BUILD_DIR/temp"

mkdir -p "$BUILD_DIR" "$TEMP_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Building all iOS frameworks with SDK 26.1.1${NC}"
echo "This will take 20-30 minutes..."
echo ""

# Alamofire checksum (already built)
echo "Alamofire=58a9c3654ed503fedc238ed17df5d9e072cef3a4ee544d0f98eeee68b979f4ff" > "$BUILD_DIR/checksums.txt"
echo -e "${GREEN}✓ Alamofire already built${NC}"

# Build JWTDecode
echo -e "${BLUE}Building JWTDecode...${NC}"
cd "$TEMP_DIR"
rm -rf JWTDecode
git clone --branch 3.2.0 --depth 1 https://github.com/auth0/JWTDecode.swift.git JWTDecode
cd JWTDecode

xcodebuild archive -scheme "JWTDecode-iOS" -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/JWTDecode-ios.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO > /dev/null 2>&1

xcodebuild archive -scheme "JWTDecode-iOS" -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/JWTDecode-sim.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO > /dev/null 2>&1

cd "$OUTPUT_DIR"
rm -rf JWTDecode.xcframework
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/JWTDecode-ios.xcarchive/Products/Library/Frameworks/JWTDecode.framework" \
  -framework "$BUILD_DIR/JWTDecode-sim.xcarchive/Products/Library/Frameworks/JWTDecode.framework" \
  -output "JWTDecode.xcframework" > /dev/null 2>&1

rm -f JWTDecode.xcframework.zip
ditto -c -k --sequesterRsrc --keepParent JWTDecode.xcframework JWTDecode.xcframework.zip
CHECKSUM=$(swift package compute-checksum JWTDecode.xcframework.zip)
echo "JWTDecode=$CHECKSUM" >> "$BUILD_DIR/checksums.txt"
echo -e "${GREEN}✓ JWTDecode complete - $CHECKSUM${NC}"

# Build Kingfisher
echo -e "${BLUE}Building Kingfisher...${NC}"
cd "$TEMP_DIR"
rm -rf Kingfisher
git clone --branch 8.1.1 --depth 1 https://github.com/onevcat/Kingfisher.git
cd Kingfisher

xcodebuild archive -scheme "Kingfisher" -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/Kingfisher-ios.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO > /dev/null 2>&1

xcodebuild archive -scheme "Kingfisher" -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/Kingfisher-sim.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO > /dev/null 2>&1

cd "$OUTPUT_DIR"
rm -rf Kingfisher.xcframework
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/Kingfisher-ios.xcarchive/Products/Library/Frameworks/Kingfisher.framework" \
  -framework "$BUILD_DIR/Kingfisher-sim.xcarchive/Products/Library/Frameworks/Kingfisher.framework" \
  -output "Kingfisher.xcframework" > /dev/null 2>&1

rm -f Kingfisher.xcframework.zip
ditto -c -k --sequesterRsrc --keepParent Kingfisher.xcframework Kingfisher.xcframework.zip
CHECKSUM=$(swift package compute-checksum Kingfisher.xcframework.zip)
echo "Kingfisher=$CHECKSUM" >> "$BUILD_DIR/checksums.txt"
echo -e "${GREEN}✓ Kingfisher complete - $CHECKSUM${NC}"

# Build DGCharts
echo -e "${BLUE}Building DGCharts...${NC}"
cd "$TEMP_DIR"
rm -rf Charts
git clone --branch 5.1.0 --depth 1 https://github.com/danielgindi/Charts.git
cd Charts

xcodebuild archive -scheme "DGCharts" -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/DGCharts-ios.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO > /dev/null 2>&1

xcodebuild archive -scheme "DGCharts" -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/DGCharts-sim.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES IPHONEOS_DEPLOYMENT_TARGET=14.0 \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO > /dev/null 2>&1

cd "$OUTPUT_DIR"
rm -rf DGCharts.xcframework
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/DGCharts-ios.xcarchive/Products/Library/Frameworks/DGCharts.framework" \
  -framework "$BUILD_DIR/DGCharts-sim.xcarchive/Products/Library/Frameworks/DGCharts.framework" \
  -output "DGCharts.xcframework" > /dev/null 2>&1

rm -f DGCharts.xcframework.zip
ditto -c -k --sequesterRsrc --keepParent DGCharts.xcframework DGCharts.xcframework.zip
CHECKSUM=$(swift package compute-checksum DGCharts.xcframework.zip)
echo "DGCharts=$CHECKSUM" >> "$BUILD_DIR/checksums.txt"
echo -e "${GREEN}✓ DGCharts complete - $CHECKSUM${NC}"

# Build Realm
echo -e "${BLUE}Building Realm (this takes longest - 10-15 min)...${NC}"
cd "$TEMP_DIR"
rm -rf realm-swift
git clone --branch v10.54.0 --depth 1 https://github.com/realm/realm-swift.git
cd realm-swift

# Get Xcode version for configuration
XCODE_VERSION_MAJOR=$(xcodebuild -version | head -n 1 | awk '{print $2}' | sed 's/\.//g' | cut -c1-4)
echo "Configuring Realm for Xcode $XCODE_VERSION_MAJOR (iOS 16.0, Swift 6.0)..."

CONFIG_FILE="Configuration/Base.xcconfig"

# Add version-specific SWIFT_VERSION if not present
if ! grep -q "SWIFT_VERSION_${XCODE_VERSION_MAJOR}" "$CONFIG_FILE"; then
    sed -i.bak1 "/^SWIFT_VERSION_1600/a\\
SWIFT_VERSION_${XCODE_VERSION_MAJOR} = 6.0;
" "$CONFIG_FILE"
fi

# Add version-specific IPHONEOS_DEPLOYMENT_TARGET if not present
if ! grep -q "IPHONEOS_DEPLOYMENT_TARGET_${XCODE_VERSION_MAJOR}" "$CONFIG_FILE"; then
    sed -i.bak2 "/^IPHONEOS_DEPLOYMENT_TARGET_1600/a\\
IPHONEOS_DEPLOYMENT_TARGET_${XCODE_VERSION_MAJOR} = 16.0;
" "$CONFIG_FILE"
fi

# Add fallback SWIFT_VERSION\nif ! grep -q \"^SWIFT_VERSION = \" \"$CONFIG_FILE\"; then\n    echo \"SWIFT_VERSION = 6.0;\" >> \"$CONFIG_FILE\"\nfi\n\n# Change SWIFT_VERSION_1600 from 5.7 to 6.0\nsed -i.bak3 \"s/^SWIFT_VERSION_1600 = 5.7;/SWIFT_VERSION_1600 = 6.0;/\" \"$CONFIG_FILE\"\n\n./build.sh xcframework > /dev/null 2>&1

cd "$OUTPUT_DIR"
rm -rf Realm.xcframework RealmSwift.xcframework
cp -R "$TEMP_DIR/realm-swift/build/ios/Realm.xcframework" .
cp -R "$TEMP_DIR/realm-swift/build/ios/RealmSwift.xcframework" .

rm -f Realm.xcframework.zip RealmSwift.xcframework.zip
ditto -c -k --sequesterRsrc --keepParent Realm.xcframework Realm.xcframework.zip
CHECKSUM=$(swift package compute-checksum Realm.xcframework.zip)
echo "Realm=$CHECKSUM" >> "$BUILD_DIR/checksums.txt"
echo -e "${GREEN}✓ Realm complete - $CHECKSUM${NC}"

ditto -c -k --sequesterRsrc --keepParent RealmSwift.xcframework RealmSwift.xcframework.zip
CHECKSUM=$(swift package compute-checksum RealmSwift.xcframework.zip)
echo "RealmSwift=$CHECKSUM" >> "$BUILD_DIR/checksums.txt"
echo -e "${GREEN}✓ RealmSwift complete - $CHECKSUM${NC}"

echo ""
echo -e "${GREEN}All frameworks built successfully!${NC}"
echo ""
echo "Checksums:"
cat "$BUILD_DIR/checksums.txt"
