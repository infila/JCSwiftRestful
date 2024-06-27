import JCSwiftCommon
import JCSwiftRestful
import XCTest

class Tests: XCTestCase {
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // This is an example of a functional test case.
    XCTAssert(true, "Pass")
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }

  func testJCRequestError() {
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
