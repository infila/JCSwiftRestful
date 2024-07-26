//
//  Thread+Ext.swift
//  JCSwiftCommon
//
//  Created by James Chen on 2022/10/31.
//

import Foundation

public extension Thread {
  static func synchronized(_ lock: AnyObject, _ closure: () -> Void) {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    closure()
  }

  /// execute the block on main thread
  static func mainThreadExecute(block: (() -> Void)?) {
    if Thread.isMainThread {
      block?()
    } else {
      DispatchQueue.main.async {
        block?()
      }
    }
  }
}
