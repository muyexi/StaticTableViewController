// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "StaticTableViewController",
	platforms: [
		.iOS(.v8)
	],
    products: [
        .library(name: "StaticTableViewController", targets: ["StaticTableViewController"]),
    ],
    targets: [
        .target(
            name: "StaticTableViewController",
            path: "Sources"
        )
    ]    
)
