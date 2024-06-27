//
//  JCRequestUtility.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2022/11/01.
//

import Foundation
import JCSwiftCommon

final class JCRequestUtility {
  public static func object2Data(_ obj: Codable?) -> Data? {
    guard let obj = obj else {
      return nil
    }
    return JCSerialization.encode(obj)
  }

  public static func object2UrlParameters(_ obj: Codable?) -> [String: String]? {
    guard let obj = obj else {
      return nil
    }
    let dic = JCSerialization.convertObject(obj)
    return parameterInDic(dic)
  }
}

private extension JCRequestUtility {
  static func parameterInDic(_ dic: [String: Any]) -> [String: String] {
    var result = [String: String]()
    for (key, value) in dic {
      if let value = value as? String {
        result.updateValue(value, forKey: key)
      } else if let subDic = value as? Dictionary<String, Any> {
        result.merge(parameterInDic(subDic)) { _, new in new }
      } else {
        result.updateValue(String(describing: value), forKey: key)
      }
    }
    return result
  }
}
