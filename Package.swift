// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SimpleAlertSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "SimpleAlertSDK",
            targets: ["SimpleAlertSDK"]),
    ],
    dependencies: [
        // Buraya varsa dışarıdan bağımlılıklar eklenebilir
    ],
    targets: [
        .target(
            name: "SimpleAlertSDK",
            dependencies: [],
            path: "Sources/SimpleAlertSDK"), // Kaynak dosyalarının yolu
        .testTarget(
            name: "SimpleAlertSDKTests",
            dependencies: ["SimpleAlertSDK"],
            path: "Tests/SimpleAlertSDKTests") // Test dosyalarının yolu burada
    ]
)

