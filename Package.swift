// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "dark-mode-notify",
    platforms: [
        .macOS(.v10_14)
    ],
    targets: [
    	.target(
		name: "dark-mode-notify",
		path: "."
	)
    ]
)

