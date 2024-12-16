// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  // or maybe this is called: w3w-swift-presenters-map
  name: "w3w-swift-components-map",
  
  platforms: [.iOS(.v13)],
  
  products: [
    .library(name: "W3WSwiftComponentsMap", targets: ["W3WSwiftComponentsMap"]),
  ],
  
  dependencies: [
    .package(url: "https://github.com/what3words/w3w-swift-themes.git", "1.0.0"..<"2.0.0"),
    .package(url: "https://github.com/what3words/w3w-swift-design.git", "1.0.0"..<"2.0.0"),
    .package(url: "https://github.com/what3words/w3w-swift-core.git", "1.0.0"..<"2.0.0"),
    .package(url: "https://github.com/what3words/w3w-swift-components.git", "3.0.0"..<"4.0.0")
  ],
  
  targets: [
    .target(name: "W3WSwiftComponentsMap", dependencies: [
      .product(name: "W3WSwiftCore", package: "w3w-swift-core"),
      .product(name: "W3WSwiftDesign", package: "w3w-swift-design"),
      .product(name: "W3WSwiftThemes", package: "w3w-swift-themes"),
      .product(name: "W3WSwiftComponents", package: "w3w-swift-components")
    ]),
    .testTarget(name: "w3w-swift-components-mapTests", dependencies: ["W3WSwiftComponentsMap"]),
  ]
)
