//
//  JCRequestDataTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-18.
//  Copyright © 2024 James Chen. All rights reserved.
//

import XCTest
import JCSwiftRestful

private struct ExampleRequest: JCRequestData {
  let apiPath = "/people"
  let method: JCHttpMethod = .post
  let header = ["Content-Type": "application/json"]
  let parameter: Codable? = ["name": "A"]
}

final class JCRequestDataTestCase: XCTestCase {
  func testRequestValuesThroughProtocol() {
    let request: JCRequestData = ExampleRequest()
    XCTAssertEqual(request.apiPath, "/people")
    XCTAssertEqual(request.method.rawValue, "post")
    XCTAssertEqual(request.header["Content-Type"], "application/json")
    XCTAssertEqual(request.parameter as? [String: String], ["name": "A"])
  }
}
