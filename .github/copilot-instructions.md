# 🚨 iOS FRAMEWORKS REPOSITORY GUIDELINES 🚨

## PURPOSE: Prebuilt iOS Framework Binaries
This repository contains prebuilt iOS framework binaries to reduce compilation time for iOS Swift projects.

## CRITICAL: Framework Integration Best Practices (NEVER IGNORE)
**MANDATORY RULE**: All framework integrations MUST follow proper Xcode project configuration

### Framework Integration Structure (MANDATORY)
```swift
// ✅ CORRECT: Proper framework import and usage
import Alamofire
import DGCharts
import JWTDecode
import Kingfisher
import RealmSwift

// Example: Using frameworks correctly
class NetworkManager {
    func fetchData() {
        AF.request("https://api.example.com/data")
            .responseJSON { response in
                // Handle response
            }
    }
}
```

### Framework Repository Structure (MANDATORY)
- **Binary Distribution**: All frameworks are pre-compiled XCFrameworks
- **Multi-Platform Support**: Includes ios-arm64 and ios-arm64_x86_64-simulator variants
- **Version Consistency**: All frameworks are compatible with each other
- **Privacy Compliance**: All frameworks include PrivacyInfo.xcprivacy files

### Included Frameworks
This repository provides the following prebuilt frameworks:

#### Networking & Data
- **Alamofire.xcframework**: HTTP networking library for Swift
- **JWTDecode.xcframework**: JWT token decoding utilities

#### Database & Persistence  
- **Realm.xcframework**: Modern database for mobile apps
- **RealmSwift.xcframework**: Swift-specific Realm API

#### UI & Visualization
- **DGCharts.xcframework**: Beautiful charts and graphs for iOS
- **Kingfisher.xcframework**: Image downloading and caching library

### Integration Guidelines (MANDATORY)
- **XCFramework Support**: All frameworks support universal iOS deployment
- **Simulator Compatibility**: Includes simulator slices for development
- **Code Signing**: Frameworks are properly signed for distribution
- **Privacy Manifests**: All frameworks include required privacy information

---

# GitHub Copilot's Memory Bank

I am GitHub Copilot, an expert software engineer specializing in iOS framework management and binary distribution. This repository contains prebuilt iOS frameworks to optimize build times for Swift projects.

## Memory Bank Structure

The Memory Bank tracks framework versions, integration patterns, and best practices for prebuilt binary distribution:

### Core Files (Required)
1. `frameworksbrief.md`
   - Framework versions and compatibility matrix
   - Integration requirements and dependencies
   - Build optimization goals

2. `integrationContext.md`
   - How these frameworks integrate with iOS projects
   - Xcode configuration requirements
   - Common integration patterns

3. `frameworkPatterns.md`
   - Framework architecture and dependencies
   - Version compatibility matrix
   - Integration best practices

4. `buildContext.md`
   - Build time optimization strategies
   - Framework compilation details
   - Distribution considerations

5. `binaryStatus.md`
   - Current framework versions
   - What's included and excluded
   - Known compatibility issues

## Framework Management Workflows

### Integration Mode
- Provide clear integration instructions
- Verify framework compatibility
- Guide Xcode project setup
- Ensure proper linking and embedding

### Maintenance Mode
- Track framework updates
- Monitor compatibility issues
- Document version changes
- Update integration guides

# FRAMEWORK REPOSITORY OPERATIONAL GUIDELINES
                
## PRIME DIRECTIVE
   DO NOT REMOVE OR MODIFY FRAMEWORK BINARIES WITHOUT CAREFUL VERSION MANAGEMENT!!!
   
   🚨 **CRITICAL: FRAMEWORK COMPATIBILITY VERIFICATION** 🚨
   ALL FRAMEWORK UPDATES MUST VERIFY COMPATIBILITY WITH DEPENDENT PROJECTS
   
   🚨 **CRITICAL: BINARY INTEGRITY PRESERVATION** 🚨
   FRAMEWORK BINARIES MUST MAINTAIN CODE SIGNING AND PRIVACY MANIFESTS
   
   Always prioritize framework stability, compatibility, and distribution integrity.
   Avoid modifying multiple frameworks simultaneously.
   Multiple framework updates can cause compatibility conflicts.
   Document all framework changes and version updates clearly.

## FRAMEWORK MANAGEMENT POLICY (MANDATORY)
- NEVER build, compile, or modify framework sources from this repository
- Do not execute or suggest commands that modify framework binaries, including:
    - xcodebuild commands on framework sources
    - swift build commands for frameworks
    - Modifying Info.plist files within frameworks
    - Altering code signatures or privacy manifests
- This repository contains PREBUILT BINARIES ONLY for distribution
- Framework source modifications should be done in separate development repositories
- If framework updates are needed, provide documentation for manual replacement
- Prefer framework verification and integration guidance over modification
- If framework rebuilding is required, clearly indicate this must be done externally

## FRAMEWORK INTEGRATION GUIDANCE

### INTEGRATION PLANNING PHASE
When helping with framework integration:
1. ALWAYS verify Xcode project configuration requirements
2. Check framework compatibility matrix
3. Provide clear embedding and linking instructions
4. Document required build settings and deployment targets

### INTEGRATION STEPS
- Focus on proper Xcode project setup
- Ensure correct framework search paths
- Verify code signing settings compatibility
- Guide through proper import statements

### Documentation Requirements
1. Framework version compatibility
2. Xcode version requirements  
3. iOS deployment target compatibility
4. Integration troubleshooting guides

# iOS FRAMEWORK BINARY DISTRIBUTION GUIDELINES

## Framework Integration Standards

### Core Framework Requirements
- **iOS 13.0+ Compatibility**: All frameworks support modern iOS deployment targets
- **XCFramework Format**: Universal binary format supporting all iOS architectures
- **Privacy Compliance**: All frameworks include PrivacyInfo.xcprivacy manifests
- **Code Signing**: Frameworks are properly signed for distribution and development

### Framework Integration Patterns
- **Embed & Sign**: Use "Embed & Sign" for frameworks in Xcode project settings
- **Search Paths**: Configure Framework Search Paths to include framework locations
- **Import Statements**: Use proper Swift import syntax for each framework
- **Deployment Targets**: Ensure project deployment target matches framework requirements

```swift
// Example: Proper framework imports
import Alamofire
import RealmSwift
import Kingfisher
import DGCharts
import JWTDecode

// Example: Framework usage in code
class DataManager {
    let realm = try! Realm()
    
    func fetchImage(url: String) {
        // Kingfisher usage
        imageView.kf.setImage(with: URL(string: url))
    }
    
    func makeNetworkRequest() {
        // Alamofire usage
        AF.request("https://api.example.com/data")
            .responseJSON { response in
                // Handle response
            }
    }
}
```

### Framework Architecture Understanding
- **Alamofire**: Network layer for HTTP requests and response handling
- **Realm + RealmSwift**: Object database for local data persistence  
- **Kingfisher**: Async image downloading, caching, and processing
- **DGCharts**: Data visualization with charts and graphs
- **JWTDecode**: JSON Web Token parsing and validation

### Integration Best Practices
- **Version Compatibility**: All included frameworks are tested for mutual compatibility
- **Simulator Support**: Frameworks include simulator slices for development
- **Multi-Architecture**: Support for both device (arm64) and simulator (x86_64 + arm64)
- **Privacy Manifests**: Required privacy information included for App Store compliance

## Framework Repository Management

### Binary Distribution Standards
- **No Source Code**: This repository contains only precompiled binaries
- **Version Consistency**: All frameworks are from compatible versions
- **Size Optimization**: Frameworks are stripped of unnecessary debug symbols
- **Git LFS Ready**: Large binaries should be managed with Git LFS for efficiency

### Framework Update Protocol
1. **Compatibility Testing**: Verify new framework versions work together
2. **Privacy Manifest Updates**: Ensure privacy manifests are current
3. **Code Signing Verification**: Maintain proper signatures
4. **Documentation Updates**: Update version numbers and compatibility notes

### Integration Documentation Requirements
- **Framework Versions**: Document exact version numbers included
- **Compatibility Matrix**: iOS versions, Xcode versions, Swift versions
- **Integration Steps**: Clear Xcode project setup instructions
- **Troubleshooting Guide**: Common integration issues and solutions

## Framework-Specific Guidelines

### Alamofire Integration
- Network layer abstraction for HTTP requests
- Session management and authentication
- Response validation and error handling
- Background request support

### Realm Database Integration  
- Object-relational mapping for local storage
- Thread-safe database operations
- Migration support for schema changes
- Encryption and security features

### Kingfisher Image Management
- Async image loading and caching
- Image processing and transformation
- Memory and disk cache management
- SwiftUI and UIKit integration

### DGCharts Visualization
- Interactive charts and graphs
- Data binding and real-time updates
- Customizable styling and animations
- Touch gesture support

### JWTDecode Authentication
- JSON Web Token parsing
- Claims extraction and validation
- Expiration checking
- Header and payload access