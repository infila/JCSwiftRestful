//
//  GetUserInfoRequestData.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2025-07-03.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import JCSwiftRestful

struct GetUserInfoRequestData: JCRequestData {
  struct Response: Codable {
  }

  var apiPath: String {
    "/v2/api/manager/customer/user"
  }
}
