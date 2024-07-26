//
//  Array+Ext.swift
//  JCSwiftCommon
//
//  Created by James Chen on 2022/10/31.
//

import Foundation

public extension Array where Element: Equatable {
  mutating func remove(_ element: Element, onlyFirst: Bool = false) {
    if let index = firstIndex(of: element) {
      remove(at: index)
    }
    if onlyFirst { return }

    while true {
      if let index = firstIndex(of: element) {
        remove(at: index)
      } else {
        break
      }
    }
  }

  /// Remove duplicated Element in array
  var unique: [Element] {
    var uniqueValues: [Element] = []
    forEach { item in
      if !uniqueValues.contains(item) {
        uniqueValues.append(item)
      }
    }
    return uniqueValues
  }
}
