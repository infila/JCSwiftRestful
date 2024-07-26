//
//  JCRequestData+Default.swift
//  JCSwiftRestful_Example
//
//  Created by James Chen on 2024-07-26.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import JCSwiftRestful

extension JCRequestData {
  var method: JCHttpMethod {
    return .get
  }

  var parameter: Codable? {
    return nil
  }

  var header: [String: String] {
    var header = [String: String]()
    header["Accept"] = "application/json, text/plain, */*"
    header["Accept-Language"] = "en-US,en;q=0.9"
    header["Content-Type"] = "application/json"
    header["source"] = "iOS"
//    if let token = UserManager.shared.userToken, token.count != 0 {
//      header["Authorization"] = "userToken"
//    }
    return header
  }
}
