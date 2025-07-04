//
//  CurrencyTestRequestData.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2025-07-03.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import JCSwiftRestful

struct CurrencyTestRequestData: JCRequestData {
  struct Response: Codable {
    var rates: Dictionary<String, Double>
  }

  var apiPath: String {
    "https://api.frankfurter.dev/v1/latest?base=USD&symbols=CAD"
  }
}
