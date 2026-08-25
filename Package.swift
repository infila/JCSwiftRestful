// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "JCSwiftRestful",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "JCSwiftRestful",
      targets: ["JCSwiftRestful"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/infila/JCSwiftCommon.git",
      from: "1.1.0"
    ),
  ],
  targets: [
    .target(
      name: "JCSwiftRestful",
      dependencies: [
        .product(
          name: "JCSwiftCommon",
          package: "JCSwiftCommon"
        ),
      ],
      path: "JCSwiftRestful/Classes"
    ),
  ]
)
