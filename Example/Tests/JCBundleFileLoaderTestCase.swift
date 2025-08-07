//
//  JCBundleFileLoaderTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-08.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftCommon
import XCTest

class JCBundleFileLoaderTestCase: XCTestCase {
    override func invokeTest() {
      testExample()
    }
    
  func testExample() {
    let people = JCBundleFileLoader.loadJsonFile(from: "PersonDemo.json", decodeType: [Person].self)
    XCTAssert(people?.count == 2)
  }
}
