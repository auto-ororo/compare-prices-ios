// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.41.2"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.43.1")
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
