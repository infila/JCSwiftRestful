# JCSwiftRestful

[![CI Status](https://img.shields.io/travis/James/JCSwiftRestful.svg?style=flat)](https://travis-ci.org/James/JCSwiftRestful)
[![Version](https://img.shields.io/cocoapods/v/JCSwiftRestful.svg?style=flat)](https://cocoapods.org/pods/JCSwiftRestful)
[![License](https://img.shields.io/cocoapods/l/JCSwiftRestful.svg?style=flat)](https://cocoapods.org/pods/JCSwiftRestful)
[![Platform](https://img.shields.io/cocoapods/p/JCSwiftRestful.svg?style=flat)](https://cocoapods.org/pods/JCSwiftRestful)

## Introduction

Here are three frameworks for junior developers. They can help you increase development efficiency and write more standardized, maintainable code.:

[JCSwiftCommon](https://github.com/infila/JCSwiftCommon): for extensions, some common function, and a lightweight local storage tool based on file system IO.

[JCSwiftRestful](https://github.com/infila/JCSwiftRestful): for Restful APIs. It helps you focus more on handling object-oriented and structured data. To use this framework, you will have to write code using more standard RESTful semantics, both on iOS and server sides. Otherwise, the automatic serialization and deserialization functions within this framework will not work.

[JCSwiftUIWedgets](https://github.com/infila/JCSwiftRestful): contains some custom components. Since many native SwiftUI methods do not support iOS 13 or 14, I have written some components to support these versions. And all components support "theme mode", which meaning you only need to modify one config, and the appearance will change everywhere.

## Example

<!--To run the example project, clone the repo, and run `pod install` from the Example directory first.-->
**3 steps to get results from a RESTful API:**
 
*Step 1: Have a default implementation for JCRequestData, which is a protocol
 ```ruby
 extension JCRequestData {
  var method: JCHttpMethod {
    return .get
  }

  var parameter: Codable? {
    return nil
  }

  var header: [String: String] {
    var header = [String: String]()
    header["Accept"] = "application/json, text/plain, */*"
    header["Accept-Language"] = "en-US,en;q=0.9"
    header["Content-Type"] = "application/json"
    header["source"] = "iOS"
//    if let token = UserManager.shared.userToken, token.count != 0 {
//      header["Authorization"] = "userToken"
//    }
    return header
  }
}
```
*Step 2: Looking at the json string in response and translate to a Swift Struct/Class
```ruby
$ curl http://ip.jsontest.com
{"ip": "24.84.236.255"}
```

Translate to (Here I name it as IpTestRequestData, and it's' response only have one property is "ip" as a String):
```ruby
private struct IpTestRequestData: JCRequestData {
  struct Response: Codable {
    var ip: String
  }

  var apiPath: String {
    "http://ip.jsontest.com"
  }
}
```

*Step 3: Send request and get result
```ruby
Task {
    let result = try? await JCRequestCenter.shared.sendRequest(IpTestRequestData(), decodeType: IpTestRequestData.Response.self)
    print(result?.ip ?? "Error")
}
```


## Requirements

iOS Deployment Target >= 13.0 

To use JCSwiftRestful, the HTTP response **MUST** adhere to standard RESTful formats. Which means: when the status code is 200, the responseData must follow a single data format, and 5XX codes should be used to indicate parameter errors or other issues. [List of HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes). 

For example, if an API returns like:
```ruby
{statusCode: 200, responseData: [Person]}
```
And in any other cases with different parameters sent from client, this API **SHOULD NOT** returns like:
```ruby
{statusCode: 200, responseData: Person}

{statusCode: 200, responseData: { errorMsg: "Parameter is incorrect" }}
```


## Installation

JCSwiftRestful is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JCSwiftRestful'
```

## Author

James, infilachen@gmail.com, [LinkedIn](https://www.linkedin.com/in/jameschen5428)

Fanny, fanfan.feng9@gmail.com

## License

JCSwiftRestful is available under the MIT license. See the LICENSE file for more info.
