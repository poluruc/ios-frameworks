// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ios-frameworks",
    platforms: [
        .iOS(.v16)
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
            checksum: "f9352ddeb3521720ed12d7db9becde664f488bc7489306c9632fffd88d393302"
        ),
        .binaryTarget(
            name: "JWTDecode",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/JWTDecode.xcframework.zip",
            checksum: "f930e9619447f0e91e1621fde11d97d639588c44b38392c0ef695a9a80fd0f05"
        ),
        .binaryTarget(
            name: "Kingfisher",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Kingfisher.xcframework.zip",
            checksum: "8996e21bbe785bb94b173de06979272bc14842e84a7dbd06039a6579d309ff84"
        ),
        .binaryTarget(
            name: "Realm",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Realm.xcframework.zip",
            checksum: "bf04b1638001f71d85ade827762f2628ee1b1da7c970c2d62587936ff6f2b411"
        ),
        .binaryTarget(
            name: "RealmSwift",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/RealmSwift.xcframework.zip",
            checksum: "686932bb0dfa286f1b8874a2597e1d97fc189144c0a872cce623be55ccbecc5a"
        ),
        .binaryTarget(
            name: "DGCharts",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/DGCharts.xcframework.zip",
            checksum: "b0fd676f5179662ec1df015ee7147588ec8f86eac074606c5d5a28e330fe6e28"
        )
    ]
)