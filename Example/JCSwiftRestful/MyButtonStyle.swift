//
//  MyButtonStyle.swift
//  JCSwiftRestful_Example
//
//  Created by James Chen on 2024-07-29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftUIWedgets
import SwiftUI

struct MyButtonStyle {
  static let regular = JCButtonStyle.GradientBackground(width: 78,
                                                        height: 44,
                                                        colors: [JCColorPair(normal: Color.purple.opacity(0.7),
                                                                             highlight: Color.purple.opacity(0.9)),
                                                                 JCColorPair(normal: Color.blue.opacity(0.7),
                                                                             highlight: Color.blue.opacity(0.9))])
  static let delete = JCButtonStyle.FixedSizeRounded(width: 100,
                                                     height: 40,
                                                     textFont: JCThemeFont.shared.M,
                                                     textColor: JCColorPair(normal: .white, highlight: .white),
                                                     backgroundColor: JCColorPair(normal: .red, highlight: .red.opacity(0.6)), strokeColor: JCColorPair(normal: .red, highlight: .red))
}
