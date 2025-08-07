import JCSwiftCommon
import JCSwiftRestful
import XCTest

class Tests: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    JCRequestErrorTestCase().invokeTest()
    JCRequestCenterTestCase().invokeTest()
    JCRequestUtilityTestCase().invokeTest()
    JCLocalPersistentTestCase().invokeTest()
    JCSerializationTestCase().invokeTest()
    JCBundleFileLoaderTestCase().invokeTest()
    JCRestfulObjectTestCase().invokeTest()
    XCTAssert(true, "Pass")
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
}
