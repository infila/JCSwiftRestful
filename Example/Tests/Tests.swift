import JCSwiftCommon
import JCSwiftRestful
import XCTest

class Tests: XCTestCase {
  override func setUp() {
    super.setUp()
    JCRequestErrorTestCase().invokeTest()
    JCRequestCenterTestCase().invokeTest()
    JCRequestUtilityTestCase().invokeTest()
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
}
