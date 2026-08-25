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

Choose **Up to Next Major Version** starting at `1.1.0` and add the `JCSwiftRestful` product to your app target. Swift Package Manager resolves `JCSwiftCommon` automatically, then:

```swift
import JCSwiftRestful
```

For a `Package.swift` manifest:

```swift
dependencies: [
  .package(url: "https://github.com/infila/JCSwiftRestful.git", from: "1.1.0")
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
pod 'JCSwiftCommon', :git => 'https://github.com/infila/JCSwiftCommon.git', :tag => '1.1.0'
pod 'JCSwiftRestful', :git => 'https://github.com/infila/JCSwiftRestful.git', :tag => '1.1.0'
```

## Authors

James Chen — infilachen@gmail.com — [LinkedIn](https://www.linkedin.com/in/jameschen5428)

Fanny Feng — fanfan.feng9@gmail.com

## License

JCSwiftRestful is available under the MIT license. See [LICENSE](LICENSE).
