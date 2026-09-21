//
//  JCSerializationTestCase.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-22.
//  Copyright © 2024 James Chen. All rights reserved.
//

import JCSwiftCommon
import XCTest

class JCSerializationTestCase: XCTestCase {

  func testObjectToDict() {
    let person1 = Person(name: "A", age: 18)
    let person2 = Person(name: "B", age: 19, children: [person1])

    let dict1 = JCSerialization.objectToDict(person1)
    let dict2 = JCSerialization.objectToDict(person2)
    XCTAssert(dict1.count == 2)
    XCTAssert(dict2.count == 3)
  }

  func testCodable() {
    let person1 = Person(name: "A", age: 18)
    let person2 = Person(name: "B", age: 19, children: [person1])

    let data = JCSerialization.encode(person2)
    let person3 = JCSerialization.decode(from: data!, decodeType: Person.self)

    XCTAssert(JCSerialization.isJsonEqual(person2, person3))

    let string = JCSerialization.jsonString(person2)
    let person4 = JCSerialization.convertJsonString(string!, toInstanceType: Person.self)
    XCTAssert(JCSerialization.isJsonEqual(person3, person4))
  }
}
