// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
        .library(
            name: "NetworkingInterfaces",
            targets: ["NetworkingInterfaces"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NetworkingInterfaces",
            path: "Interfaces"
        ),
        .target(
            name: "Networking",
            dependencies: ["NetworkingInterfaces"],
            path: "Sources"
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            path: "Tests")
    ]
)
