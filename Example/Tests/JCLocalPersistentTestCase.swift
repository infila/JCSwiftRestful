//
//  JCLocalPersistentTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-05.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftCommon
import XCTest

class Person: JCPersistentObject {
  var id: String {
    return name
  }

  var name: String
  var age: Int

  var children: [Person]?

  init(name: String, age: Int, children: [Person]? = nil) {
    self.name = name
    self.age = age
    self.children = children
  }
}

class JCLocalPersistentTestCase: XCTestCase {
  func testExample() {
    Person.clear()
    let allFileAmount = JCLocalPersistent.shared.allFileName().count
    let person1 = Person(name: "A", age: 18)
    let person2 = Person(name: "B", age: 19)

    XCTAssert(person1.save())
    XCTAssert(person2.save())

    var people = [Person].load()
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

    let newAllFileAmount = JCLocalPersistent.shared.allFileName().count
    XCTAssert(newAllFileAmount - allFileAmount == 1)

    Person.clear()
    XCTAssert([Person].load().count == 0)
  }
}