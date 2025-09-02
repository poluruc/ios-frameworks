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
            checksum: "f1b28c3fc7f0e812f5d7b099fbc2007dfa698bd35858e490bc7d4faf98694fa9"
        ),
        .binaryTarget(
            name: "JWTDecode",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/JWTDecode.xcframework.zip",
            checksum: "8d2cc76327adbd777a1a79041d16b51bd0193cef3b8f77bb3f5d202234361c68"
        ),
        .binaryTarget(
            name: "Kingfisher",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Kingfisher.xcframework.zip",
            checksum: "a1622497a3327a4726127f9976c36378e7b79c3d0cc2dd8c4f2836bb016cb4fc"
        ),
        .binaryTarget(
            name: "Realm",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/Realm.xcframework.zip",
            checksum: "ef021fa9d65fca9829a3de73ca714fd0185b8c50dad413e967d3494b1a665b34"
        ),
        .binaryTarget(
            name: "RealmSwift",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/RealmSwift.xcframework.zip",
            checksum: "5a60f71644799f1fa14961d55872c07ce43a5344cd7195f0abde78d9ae90f09e"
        ),
        .binaryTarget(
            name: "DGCharts",
            url: "https://github.com/poluruc/ios-frameworks/raw/refs/heads/main/DGCharts.xcframework.zip",
            checksum: "de699c79f032bdf089131cee3d8b92cc9edcbde918d524a687380d056afdad71"
        )
    ]
)