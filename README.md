# JCSwiftRestful

[![Release](https://img.shields.io/github/v/tag/infila/JCSwiftRestful?label=release)](https://github.com/infila/JCSwiftRestful/tags)
![iOS](https://img.shields.io/badge/iOS-13%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.7%2B-orange)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

An async/await REST client that maps `Codable` request and response types. It depends on [JCSwiftCommon](https://github.com/infila/JCSwiftCommon).

Related package: [JCSwiftUIWidgets](https://github.com/infila/JCSwiftUIWidgets).

## Example

Provide shared defaults for requests:

```swift
extension JCRequestData {
  var method: JCHttpMethod { .get }
  var parameter: Codable? { nil }
  var header: [String: String] {
    ["Accept": "application/json"]
  }
}
```

Model the response and endpoint. For example, a response such as `{"ip":"203.0.113.10"}` can be represented by:

```swift
struct IPRequest: JCRequestData {
  struct Response: Codable {
    let ip: String
  }

  var apiPath: String { "/ip" }
}
```

Configure the server URL and send the request:

```swift
JCRequestCenter.shared.domainUrl = "https://api.example.com"

Task {
  do {
    let response = try await JCRequestCenter.shared.sendRequest(
      IPRequest(),
      decodeType: IPRequest.Response.self
    )
    print(response.ip)
  } catch {
    print(error)
  }
}
```

The example domain is illustrative; replace it with your own HTTPS API.

## Response handling

- Successful `200...299` responses are decoded directly into the requested `Codable` type.
- Other HTTP responses are decoded as `JCRequestError` when possible.
- Client validation and authorization errors should use appropriate `4xx` status codes; server failures should use `5xx` codes.
- The domain URL, timeout, cache policy, logging, success status range, encryption, and error handling can be customized on `JCRequestCenter.shared`.

## Requirements

- iOS 13 or later
- Xcode 14 or later

## Installation

### Swift Package Manager

In Xcode, select **File > Add Package Dependencies** and enter:

```text
https://github.com/infila/JCSwiftRestful.git
```

Choose **Up to Next Major Version** starting at `2.0.0` and add the `JCSwiftRestful` product to your app target. Swift Package Manager resolves `JCSwiftCommon` automatically, then:

```swift
import JCSwiftRestful
```

For a `Package.swift` manifest:

```swift
dependencies: [
  .package(url: "https://github.com/infila/JCSwiftRestful.git", from: "2.0.0")
]
```

Add the product to the dependencies of the target that imports it:

```swift
.product(name: "JCSwiftRestful", package: "JCSwiftRestful")
```

You do not need to declare `JCSwiftCommon` separately unless your own target imports it directly. Release tags follow [Semantic Versioning](https://semver.org/). Swift Package Manager is the primary distribution channel.

### CocoaPods (legacy)

CocoaPods Trunk currently contains version `1.0.5`:

```ruby
pod 'JCSwiftRestful', '~> 1.0.5'
```

To use the current Git releases, declare both dependencies explicitly:

```ruby
pod 'JCSwiftCommon', :git => 'https://github.com/infila/JCSwiftCommon.git', :tag => '2.0.0'
pod 'JCSwiftRestful', :git => 'https://github.com/infila/JCSwiftRestful.git', :tag => '2.0.0'
```

## Development

`JCSwiftRestful/Classes` contains the library. `Example/JCSwiftRestful` contains the runnable SwiftUI demo, whose entry point is `DemoApp.swift`. The demo is not compiled into the Swift package library.

### Library tests

Run the core request, error decoding, and body encoding tests on macOS:

```sh
swift test
```

These tests do not start the demo or contact a live server. The example test target also retains the JCSwiftCommon integration tests, including the app-bundle resource test.

### Run the demo

Place `JCSwiftRestful`, `JCSwiftCommon`, and `JCSwiftUIWidgets` repositories in the same parent directory, then run:

```sh
cd Example
pod install
open JCSwiftRestful.xcworkspace
```

Select the `JCSwiftRestful-Example` scheme and an iOS simulator. The SwiftUI demo requires iOS 15 or later because of its JCSwiftUIWidgets dependency; the library continues to support iOS 13. Configure the demo's server and login settings for your environment before making requests.

## Authors

James Chen — infilachen@gmail.com — [LinkedIn](https://www.linkedin.com/in/jameschen5428)

Fanny Feng — fanfan.feng9@gmail.com

## License

JCSwiftRestful is available under the MIT license. See [LICENSE](LICENSE).
