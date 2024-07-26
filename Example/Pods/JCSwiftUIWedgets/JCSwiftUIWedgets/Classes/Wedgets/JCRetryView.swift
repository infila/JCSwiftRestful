//
//  JCRetryView.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2022/12/13.
//

import SwiftUI

// Editing config.shared ensures that this component looks the same wherever it is used.
// Or have a new Config() to make it special.
public struct JCRetryViewConfig {
  static let shared = JCRetryViewConfig()

  var spacing: CGFloat = 20

  var icon: (some View)? = Image(systemName: "info.circle").mask(color: JCThemeColor.shared.primary)

  var errorTitle: String = "Network Error"
  var errorTitleFont: Font = JCThemeFont.shared.L
  var errorTitleColor: Color = JCThemeColor.shared.primary

  var errorMessageMaxWidth = UIScreen.main.bounds.width - 80
  var errorMessage: String = "Please check your network environment, and retry later."
  var errorMessageFont: Font = JCThemeFont.shared.M
  var errorMessageColor: Color = JCThemeColor.shared.secondary

  var retryButtonTitle: String = "Retry"

  var retryButtonStyle = JCButtonStyle.FixedSizeRounded(width: 78, height: 40)
}

public struct JCRetryView: View {
  var isloading: Bool = false
  var retryClicked: (() -> Void)?

  var config = JCRetryViewConfig.shared

  public var body: some View {
    ZStack {
      JCThemeColor.shared.background
      if isloading {
        JCLoadingView()
      } else {
        VStack(spacing: config.spacing) {
          HStack {
            if let icon = config.icon {
              icon
            }
            Text(config.errorTitle)
              .font(config.errorTitleFont)
              .foregroundColor(config.errorTitleColor)
              .multilineTextAlignment(.center)
          }
          Text(config.errorMessage)
            .frame(maxWidth: config.errorMessageMaxWidth)
            .font(config.errorMessageFont)
            .foregroundColor(config.errorMessageColor)
            .multilineTextAlignment(.center)
          Button {
            retryClicked?()
          } label: {
            Text(config.retryButtonTitle)
          }
          .buttonStyle(config.retryButtonStyle)
          .padding(.top)
        }
      }
    }
  }
}

#Preview {
  VStack {
    JCRetryView(isloading: false)
  }.background(Color.gray)
}
