//
//  LoginManager.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2025-07-03.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

final class LoginManager {
  static let shared = LoginManager()

  func login() {
    print("LoginManager login")
  }

  private init() {}
}
