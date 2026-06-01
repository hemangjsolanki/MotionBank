// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "MotionBank",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "MotionBank",
            targets: ["MotionBank"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MotionBank",
            dependencies: [],
            path: ".",
            sources: [
                "App",
                "DesignSystem",
                "Features",
                "Integration",
                "Models",
                "Widget"
            ]
        )
    ]
)
