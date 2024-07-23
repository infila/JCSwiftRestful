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

/// Encapsulating an API request into an object is a good habit.
/// This helps you focus on one thing at one time, and pretty easy for doing maintenance.
public protocol JCRequestData {
  var apiPath: String { get }
  var method: JCHttpMethod { get }
  var header: [String: String] { get }
  var parameter: Codable? { get }
}

// JCRequestData default implementation Example

// extension JCRequestData {
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
//    header["Accept-Language"] = "en-US,en;q=0.8"
//    header["Content-Type"] = "application/json"
//    header["App-Type"] = "iOS"
////    if let token = UserManager.shared.userToken, token.count != 0 {
////      header["authorization"] = token
////    }
//    return header
//  }
// }
