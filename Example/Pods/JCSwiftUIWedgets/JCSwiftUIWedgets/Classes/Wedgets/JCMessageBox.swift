//
//  JCMessageBox.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2022/11/7.
//

import SwiftUI

// Editing config.shared ensures that this component looks the same wherever it is used.
// Or have a new Config() to make it special.
public struct JCMessageBoxConfig {
  static let shared: JCMessageBoxConfig = JCMessageBoxConfig()

  var boxWidth: CGFloat = UIScreen.main.bounds.width / 3 * 2
  var boxHeight: CGFloat = UIScreen.main.bounds.width / 2

  var backgroundColor: Color = JCThemeColor.shared.separateLine.opacity(0.75)

  var boxBackgroundColor: Color = JCThemeColor.shared.textPrimary.opacity(0.9)

  var cornerRadius: CGFloat = 12

  var textColor: Color = JCThemeColor.shared.navigationBar
  var font: Font = JCThemeFont.shared.navigationTitle
  var alignment: TextAlignment = .center
}


public struct JCMessageBox: View {
  var message: String
  var config: JCMessageBoxConfig = JCMessageBoxConfig.shared

  public var body: some View {
    ZStack {
      config.backgroundColor
        .edgesIgnoringSafeArea(.all)
      config.boxBackgroundColor
        .frame(width: config.boxWidth, height: config.boxHeight)
        .cornerRadius(config.cornerRadius)
      Text(message)
        .multilineTextAlignment(config.alignment)
        .frame(maxWidth: config.boxWidth - 20, maxHeight: config.boxHeight - 20)
        .font(config.font)
        .minimumScaleFactor(0.7)
        .foregroundColor(config.textColor)
    }
  }
}

#Preview {
  JCMessageBox(message: "Message box with a long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long Message")
}
