// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.41.2"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.43.1"),
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "5.4.0"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
