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
        .library(name: "RealmSwift", targets: ["RealmSwift", "Realm"]),
        .library(name: "DGCharts", targets: ["DGCharts"])
    ],
    targets: [
        .binaryTarget(
            name: "Alamofire",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Alamofire.xcframework.zip",
            checksum: "58a9c3654ed503fedc238ed17df5d9e072cef3a4ee544d0f98eeee68b979f4ff"
        ),
        .binaryTarget(
            name: "JWTDecode",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/JWTDecode.xcframework.zip",
            checksum: "b5c9c93e5d3d24dcf66de0c5b866dacf85ae71c6805ce3552e498d4ba10c3c14"
        ),
        .binaryTarget(
            name: "Kingfisher",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Kingfisher.xcframework.zip",
            checksum: "e02d55e255e98f0db317092cfeec5f5411f89c0880ac18ff1a0a8e47f5eddb16"
        ),
        .binaryTarget(
            name: "Realm",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Realm.xcframework.zip",
            checksum: "9ada4b2316d0984cb1f11503a5398e8938a28ba46d8c1ec67971df57d5a5544c"
        ),
        .binaryTarget(
            name: "RealmSwift",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/RealmSwift.xcframework.zip",
            checksum: "ce68cca4fe38c6fd965f7e4e311d71b47f03af3e4c7a21fbe8646ffcefd5a9c1"
        ),
        .binaryTarget(
            name: "DGCharts",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/DGCharts.xcframework.zip",
            checksum: "112cb76b989a6ccf79f1b35004fa2637735d930fd0cd8d3eb60aec0fc1edbbdd"
        )
    ]
)