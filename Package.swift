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
        .library(name: "RealmSwift", targets: ["RealmSwiftWrapper"]),
        .library(name: "DGCharts", targets: ["DGCharts"])
    ],
    targets: [
        .target(
            name: "RealmSwiftWrapper",
            dependencies: ["Realm", "RealmSwift"]
        ),
        .binaryTarget(
            name: "Alamofire",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Alamofire.xcframework.zip",
            checksum: "58a9c3654ed503fedc238ed17df5d9e072cef3a4ee544d0f98eeee68b979f4ff"
        ),
        .binaryTarget(
            name: "JWTDecode",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/JWTDecode.xcframework.zip",
            checksum: "dcb007bcdb2ee9a0ea49fa5199d517dd9261a4c23049abeec8badf5eff38d844"
        ),
        .binaryTarget(
            name: "Kingfisher",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Kingfisher.xcframework.zip",
            checksum: "e02d55e255e98f0db317092cfeec5f5411f89c0880ac18ff1a0a8e47f5eddb16"
        ),
        .binaryTarget(
            name: "Realm",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Realm.xcframework.zip",
            checksum: "8ace2573aaa2ad74967325d2f19fe79ce173f7b37e9a0221dae8c24922f4c9d5"
        ),
        .binaryTarget(
            name: "RealmSwift",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/RealmSwift.xcframework.zip",
            checksum: "c7cc12ffb419fd9adfb67146320e9a302f51f8e366c67d0ebc8ed320ab4ee536"
        ),
        .binaryTarget(
            name: "DGCharts",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/DGCharts.xcframework.zip",
            checksum: "112cb76b989a6ccf79f1b35004fa2637735d930fd0cd8d3eb60aec0fc1edbbdd"
        )
    ]
)