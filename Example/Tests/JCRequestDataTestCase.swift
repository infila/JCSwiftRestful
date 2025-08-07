//
//  JCRequestDataTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftCommon
import JCSwiftRestful
import XCTest

private struct ValidateJsonRequest: JCRequestData {
  var apiPath: String {
    return "http://validate.jsontest.com/"
  }

  var method: JCHttpMethod {
    .post
  }

  var parameter: Codable?
}

private struct ValidateJsonResponse: Codable {
  var error: String
  var object_or_array: String
  var error_info: String
  var validate: Bool
}

class JCRestfulObjectTestCase: XCTestCase {
  override func invokeTest() {
    testPost()
  }

  func testGet() {
  }

  func testPost() {
    Task {
      do {
        let request = ValidateJsonRequest(parameter: Person(name: "A", age: 18, children: nil))
        let result = try? await JCRequestCenter.shared.sendRequest(request, decodeType: ValidateJsonResponse.self)
        XCTAssert(result?.validate == true)
      }
    }
  }
}

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
