//
//  JCRequestErrorTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-03.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftCommon
import JCSwiftRestful
import XCTest

class JCRequestErrorTestCase: XCTestCase {
  func testExample() {
    let serverErrorString1 = "{\"errorCode\":9999,\"reason\":\"45678\"}"
    let error1 = JCSerialization.decode(from: serverErrorString1.data(using: .utf8)!, decodeType: JCRequestError.self)
    XCTAssert(error1?.errorCode == 9999)
    XCTAssert(error1?.reason == "45678")

    let serverErrorString2 = "{\"error_code\":9999,\"msg\":\"45678\"}"
    JCRequestError.errorCodeNameKey = "error_code"
    JCRequestError.reasonNameKey = "msg"
    let error2 = JCSerialization.decode(from: serverErrorString2.data(using: .utf8)!, decodeType: JCRequestError.self)
    XCTAssert(error2?.errorCode == 9999)
    XCTAssert(error2?.reason == "45678")

    JCRequestError.errorCodeNameKey = "errorCode"
    JCRequestError.reasonNameKey = "reason"
    let error3 = JCSerialization.decode(from: serverErrorString1.data(using: .utf8)!, decodeType: JCRequestError.self)
    XCTAssert(error3?.errorCode == 9999)
    XCTAssert(error3?.reason == "45678")
  }
}
