//
//  JCSerialization.swift
//  JCSwiftCommon
//
//  Created by James Chen on 2022/10/18.
//

import Foundation

/// Functions for Object <-> JsonString, and Object <-> Data
public struct JCSerialization {
  /// Create an Object from Data
  public static func decode<T: Decodable>(from data: Data, decodeType: T.Type) -> T? {
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      assert(false, "Couldn't parse \(String(data: data, encoding: .utf8) ?? data.description) as \(T.self):\n\(error)")
    }
    return nil
  }

  /// Transform an Object to Data
  public static func encode<T: Encodable>(_ value: T) -> Data? {
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .sortedKeys
      return try encoder.encode(value)
    } catch {
      assert(false, "Couldn't parse \(value) to data:\n\(error)")
    }
    return nil
  }

  /// Transform an Object to Dictionary
  public static func objectToDict<T: Encodable>(_ object: T) -> [String: Any] {
    let mirror = Mirror(reflecting: object)
    let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
      guard let label = label else { return nil }
      // It says  "Conditional cast from 'Any' to 'Optional<Any>' always succeeds", but actually it's not!
      // While value: Any = Optional(nil), value == nil returns false here,
      // value == nil returns true, only after casting value: Any to Optional<Any>
      if let value = value as? Optional<Any>, value == nil {
        return nil
      }
      if let subObject = value as? Encodable {
        let subDic = self.objectToDict(subObject)
        if !subDic.isEmpty {
          return (label, subDic)
        } else {
          return (label, value)
        }
      } else {
        return (label, value)
      }
    }).compactMap { $0 })
    return dict
  }

  /// Transform an Object to JsonString
  public static func jsonString<T: Encodable>(_ instance: T, encoding: String.Encoding = .utf8) -> String? {
    guard let data = encode(instance) else {
      return nil
    }
    return String(data: data, encoding: encoding)
  }

  /// Transform a JsonString to Object
  public static func convertJsonString<T: Decodable>(_ string: String, toInstanceType: T.Type, encoding: String.Encoding = .utf8) -> T? {
    guard let data = string.data(using: encoding) else {
      return nil
    }
    return decode(from: data, decodeType: toInstanceType)
  }

  /// Return true if JsonString of these two objects is equal
  public static func isJsonEqual<T: Encodable>(_ obj1: T, _ obj2: T) -> Bool {
    return jsonString(obj1) == jsonString(obj2)
  }
}
