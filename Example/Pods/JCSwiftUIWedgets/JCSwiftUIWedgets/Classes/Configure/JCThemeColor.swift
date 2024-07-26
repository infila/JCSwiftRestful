//
//  JCThemeColor.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2023/10/20.
//

import SwiftUI

public struct JCThemeColor {
  static let shared = JCThemeColor()

  var primary: Color = Color(withHex: "#B31942") // red
  var secondary: Color = Color(withHex: "#0A3161") // blue

  var background: Color = Color(withHex: "#F0F0F0")
  var navigationBar: Color = Color(withHex: "#FFFFFF")
  var separateLine: Color = Color(withHex: "#dfdfdf")

  var success: Color = .green
  var error: Color = .red
  var warning: Color = .yellow
  var clear: Color = .clear

  var textPrimary: Color = .black
  var textSecondary: Color = .secondary

  var buttonPrimary = JCColorPair(normal: .green, highlight: .green.opacity(0.7))
  var buttonPrimaryBorder = JCColorPair(normal: .blue.opacity(0.5), highlight: .blue.opacity(0.7))
  var buttonPrimaryText = JCColorPair(normal: .white, highlight: .white)

  var buttonSecondary = JCColorPair(normal: .gray.opacity(0.3), highlight: .gray.opacity(0.7))
  var buttonSecondaryBorder = JCColorPair(normal: .secondary, highlight: .secondary.opacity(0.5))
  var buttonSecondaryText = JCColorPair(normal: .black, highlight: .secondary)
}
