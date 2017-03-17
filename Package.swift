import PackageDescription

let package = Package(
    name: "Emotion Detect",
    dependencies: [
        .Package(url: "https://github.com/peterentwistle/OpenCVWrapper.git", majorVersion: 1)
    ]
)
