//
//  Color+Ext.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2022/10/19.
//

import SwiftUI

public extension Color {
  init(withHex hexString: String) {
    let hex = hexString.replacingOccurrences(of: "#", with: "")
    assert(hex.count == 6 || hex.count == 8)
    let scanner = Scanner(string: hex)

    var color: UInt64 = 0
    scanner.scanHexInt64(&color)
    let mask: UInt64 = 0x000000FF
    var a: UInt64 = 255
    if hex.count == 8 {
      a = (color >> 24) & mask
    }
    let r = (color >> 16) & mask
    let g = (color >> 8) & mask
    let b = color & mask
    self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, opacity: CGFloat(a) / 255)
  }
}
