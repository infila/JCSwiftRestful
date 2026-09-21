//
//  JCRequestUtilityTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-03.
//  Copyright © 2024 James Chen. All rights reserved.
//

import XCTest
@testable import JCSwiftRestful

final class JCRequestUtilityTestCase: XCTestCase {
  func testMissingBody() {
    XCTAssertNil(JCRequestUtility.object2Data(nil))
    XCTAssertNil(JCRequestUtility.object2UrlParameters(nil))
  }

  func testRawBodiesArePreserved() {
    let data = Data([0, 1, 255])
    XCTAssertEqual(JCRequestUtility.object2Data(data), data)
    XCTAssertEqual(JCRequestUtility.object2Data("hello"), Data("hello".utf8))
  }

  func testCodableBodyIsJSON() throws {
    let data = try XCTUnwrap(JCRequestUtility.object2Data(["name": "A"]))
    XCTAssertEqual(try JSONDecoder().decode([String: String].self, from: data), ["name": "A"])
  }
}
