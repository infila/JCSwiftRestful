//
//  DemoApp.swift
//  JCSwiftRestful
//
//  Created by James on 06/17/2024.
//  Copyright (c) 2024 James. All rights reserved.
//

import JCSwiftRestful
import SwiftUI

@main
struct DemoApp: App {
  init() {
    configureRequestCenter()
  }

  var body: some Scene {
    WindowGroup {
      ViewRouter.shared.currentView
    }
  }

  func configureRequestCenter() {
    JCRequestCenter.shared.domainUrl = "https://sscloud.baystech.net"
    let condition: (_ statusCode: Int, _ error: JCRequestError) -> Bool = { statusCode, error in
      statusCode == 400 && error.errorCode == 30
    }
    let handler: (_ requestData: JCRequestData) -> (reqeustData: JCRequestData, data: Data?, error: Error?) = { requestData in
      let semaphore = DispatchSemaphore(value: 0)
      var result: (reqeustData: JCRequestData, data: Data?, error: Error?) = (requestData, nil, JCRequestError(errorCode: 30, reason: "Login Failed"))
      Task {
        let loginResult = await LoginManager.shared.login()
        if loginResult {
          result = await JCRequestCenter.shared.sendRequest(requestData)
        }
        semaphore.signal()
      }
      semaphore.wait()
      return result
    }
    JCRequestCenter.shared.specialHandler = [(condition, handler)]
  }
}
