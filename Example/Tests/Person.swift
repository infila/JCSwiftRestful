//
//  Person.swift
//  JCSwiftRestful_Tests
//
//  Created by James Chen on 2024-07-08.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import JCSwiftCommon

class Person: JCPersistentObject {
  func persistentId() -> String {
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
