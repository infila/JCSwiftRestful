//
//  ViewRouter.swift
//  JCSwiftRestful_Example
//
//  Created by James Chen on 2024-07-26.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI

struct ViewRouter {
  static let shared = ViewRouter()

  var currentView: some View {
    TestIpView()
  }
}
