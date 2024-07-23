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

private struct IpTestRequestData: JCRequestData {
  struct Response: Codable {
    var ip: String
  }

  var apiPath: String {
    "http://ip.jsontest.com"
  }
}

private struct ValidateJsonRequest: JCRequestData {
  var apiPath: String {
    return "http://validate.jsontest.com/"
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
  override func setUp() {
    super.setUp()
  }

  func testGet() async {
    Task {
      let result = try? await JCRequestCenter.shared.sendRequest(IpTestRequestData(), decodeType: IpTestRequestData.Response.self)
      XCTAssert(result?.ip != nil)
    }

    let expectation = expectation(description: "callback")
    let result: (Result<IpTestRequestData.Response, JCRequestError>) -> Void = { response in
      switch response {
      case let .success(outCome):
        XCTAssert(outCome.ip.count != 0)
      case let .failure(error):
        print(error)
        XCTAssert(false)
      }
      expectation.fulfill()
    }
    JCRequestCenter.shared.sendRequest(IpTestRequestData(), completion: result)
    await fulfillment(of: [expectation])
  }

  func testPost() async {
    do {
      let request = ValidateJsonRequest(parameter: Person(name: "A", age: 18, children: nil))
      let result = try? await JCRequestCenter.shared.sendRequest(request, decodeType: ValidateJsonResponse.self)
      XCTAssert(result?.validate == true)
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
