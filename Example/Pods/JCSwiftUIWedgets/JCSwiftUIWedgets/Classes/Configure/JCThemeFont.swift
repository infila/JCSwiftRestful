//
//  JCThemeFont.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2023/10/20.
//

import SwiftUI

public struct JCThemeFont {
  // font weight regular = 400, medium = 500
  static let shared = JCThemeFont()

  var navigationTitle: Font = Font.system(size: 20, weight: .medium)
  var barbutton: Font = Font.system(size: 9)

  var title: Font = Font.system(size: 20, weight: .medium)
  var subTitle: Font = Font.system(size: 14)
  var content: Font = Font.system(size: 17)

  var XXS: Font = Font.system(size: 9)
  var XS: Font = Font.system(size: 11)
  var S: Font = Font.system(size: 14)
  var M: Font = Font.system(size: 17)
  var L: Font = Font.system(size: 20)
  var XL: Font = Font.system(size: 24, weight: .medium)
  var XXL: Font = Font.system(size: 28, weight: .medium)
}
