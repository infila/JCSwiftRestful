//
//  String+Ext.swift
//  JCSwiftCommon
//
//  Created by James Chen on 2022/10/31.
//

import Foundation

public extension String {
  enum StringRandomStrategy {
    case number
    case chat
    case numberAndChat
    case numberAndChatCases
  }

  /// Genarate a Random String
  /// Pass "!@#$%." or something as additional:String to expand random pool
  static func random(withLength length: UInt, strategy: StringRandomStrategy, additional: String = "") -> String {
    var range: String = ""

    let numbers = "1234567890"
    let chats = "qwertyuiopasdfghjklzxcvbnm"

    switch strategy {
    case .number:
      range = numbers
    case .chat:
      range = chats
    case .numberAndChat:
      range = numbers + chats
    case .numberAndChatCases:
      range = numbers + chats + chats.capitalized
    }
    range = range + additional
    var randomOri = [String]()
    range.forEach { randomOri.append(String($0)) }
    var result = ""
    for _ in 0 ..< length {
      result = result + randomOri.randomElement()!
    }
    return result
  }

  /// Return type name of an instance
  init<Subject>(typeName object: Subject) {
    let mirror = Mirror(reflecting: object)
    self.init(reflecting: mirror.subjectType)
  }

  /// Find the last "." in self, and return substring after that.
  func lastComponent() -> String {
    if lastIndex(of: ".") == nil {
      return self
    }
    let component = split(separator: ".").last!
    return String(component)
  }

  func toDictionary() -> [String: Any]? {
    guard !isEmpty else { return nil }

    guard let dataSelf = data(using: .utf8) else {
      return nil
    }

    if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                                                   options: .mutableContainers) as? [String: Any] {
      return dic
    }
    return nil
  }

  func intValue() -> Int? {
    Int(self)
  }

  func doubleValue() -> Double? {
    Double(self)
  }

  func toISO8601Date(_ format: String = "yyyy") -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let date = formatter.date(from: self)
    return "\(date?.format2String(format) ?? "")"
  }
}
