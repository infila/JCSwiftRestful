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
      from: "2.0.0"
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
    .testTarget(
      name: "JCSwiftRestfulTests",
      dependencies: [
        "JCSwiftRestful",
        .product(name: "JCSwiftCommon", package: "JCSwiftCommon"),
      ],
      path: "Example/Tests",
      exclude: [
        "Info.plist", "PersonDemo.json", "Person.swift", "Tests.swift",
        "JCBundleFileLoaderTestCase.swift", "JCLocalPersistentTestCase.swift",
        "JCSerializationTestCase.swift",
      ],
      sources: [
        "JCRequestDataTestCase.swift", "JCRequestErrorTestCase.swift",
        "JCRequestUtilityTestCase.swift",
      ]
    ),
  ]
)
