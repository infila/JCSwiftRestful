//
//  JCLocalPersistentTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-05.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftCommon
import XCTest

class JCLocalPersistentTestCase: XCTestCase {
    override func invokeTest() {
      testExample()
    }
    
  func testExample() {
    Person.clear()
    let allFileAmount = JCLocalPersistent.shared.allFileNames().count
    let person1 = Person(name: "A", age: 18)
    let person2 = Person(name: "B", age: 19)

    XCTAssert(person1.save())
    XCTAssert(person2.save())

    let people = [Person].load()
    XCTAssert(people.count == 2)

    person2.age = 20
    person2.save()

    XCTAssert([Person].load().count == 2)

    person2.name = "C"
    person2.children = people
    person2.save()

    XCTAssert([Person].load().count == 3)

    let newPerson2 = Person.load(byId: "C")
    XCTAssert(newPerson2?.children?.count == 2)

    let newAllFileAmount = JCLocalPersistent.shared.allFileNames().count
    XCTAssert(newAllFileAmount - allFileAmount == 1)

    Person.clear()
    XCTAssert([Person].load().count == 0)
  }
}
