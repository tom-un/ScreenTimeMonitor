// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "ScreenTimeMonitor",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "ScreenTimeMonitor",
            targets: ["ScreenTimeMonitor"]
        ),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ScreenTimeMonitor",
            dependencies: [],
            path: "Sources/ScreenTimeMonitor"
        )
    ]
)
