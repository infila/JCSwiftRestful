//
//  JCPageIndicator.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2022/11/2.
//

import SwiftUI

// Editing config.shared ensures that this component looks the same wherever it is used.
public struct JCPageIndicatorConfig {
  static let shared = JCPageIndicatorConfig()

  var defaultColor = JCThemeColor.shared.success
  var selectedColor = JCThemeColor.shared.primary

  var dotSpacing: CGFloat = 8
  var dotDiameter: CGFloat = 5
}

public struct JCPageIndicator: View {
  var pageIndex: Int
  var total: Int

  var config = JCPageIndicatorConfig.shared

  public var body: some View {
    HStack(spacing: config.dotSpacing) {
      ForEach(0 ..< total, id: \.self) { index in
        if index == pageIndex {
          config.selectedColor.frame(width: config.dotDiameter, height: config.dotDiameter).clipShape(Circle())
        } else {
          config.defaultColor.frame(width: config.dotDiameter, height: config.dotDiameter).clipShape(Circle())
        }
      }
    }
  }
}

#Preview {
  JCPageIndicator(pageIndex: 0, total: 5, config: JCPageIndicatorConfig(selectedColor: Color.orange))
    .previewLayout(.fixed(width: 100, height: 10))
}
