//
//  DemoApp.swift
//  JCSwiftRestful
//
//  Created by James on 06/17/2024.
//  Copyright (c) 2024 James. All rights reserved.
//

import SwiftUI

@main
struct DemoApp: App {
  var body: some Scene {
    WindowGroup {
      ViewRouter.shared.currentView
    }
  }
}
