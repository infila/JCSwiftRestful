//
//  JCRequestData.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2022/11/01.
//

import Foundation

public enum JCHttpMethod: String {
  case get
  case post
  case put
  case patch
  case delete
}

public protocol JCRequestData {
  var id: String? { get }
  var apiPath: String { get }
  var method: JCHttpMethod { get }
  var header: [String: String] { get }
  var parameter: Codable? { get }
}

// JCRequestData default implementation Example

//extension JCRequestData {
//  var id: String {
//    return UUID().uuidString
//  }
//
//  var method: JCHttpMethod {
//    return .get
//  }
//
//  var parameter: Codable? {
//    return nil
//  }
//
//  var header: [String: String] {
//    var header = [String: String]()
//    header["Accept"] = "application/json, text/plain, */*"
//    header["Accept-Language"] = "en-US,en;q=0.9"
//    header["Content-Type"] = "application/json"
//    header["client-version"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
//    header["source"] = "ios"
//    if let token = UserManager.shared.userToken, token.count != 0 {
//      header["Authorization"] = "userToken"
//    }
//    return header
//  }
//}
