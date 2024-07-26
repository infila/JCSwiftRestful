//
//  JCButtonStyle.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2022/10/19.
//

import SwiftUI

public struct JCButtonStyle {
  // A fixed-size with rounded corner style
  // see JCButtonStyles_Previews for examples
  struct FixedSizeRounded: ButtonStyle {
    var width: CGFloat
    var height: CGFloat
    //  cornerRadius should be suitable
    var cornerRadius: CGFloat = 12
    var textFont: Font = JCThemeFont.shared.L
    var textColor: JCColorPair = JCColorPair(normal: JCThemeColor.shared.buttonPrimaryText.normal, highlight: JCThemeColor.shared.buttonPrimaryText.highlight)
    var backgroundColor: JCColorPair = JCColorPair(normal: JCThemeColor.shared.buttonPrimary.normal, highlight: JCThemeColor.shared.buttonPrimary.highlight)
    var strokeColor: JCColorPair? = JCColorPair(normal: JCThemeColor.shared.buttonPrimaryBorder.normal, highlight: JCThemeColor.shared.buttonPrimaryBorder.highlight)
    var strokeWidth: CGFloat = 2

    public func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .frame(width: width, height: height)
        .font(textFont)
        .background(RoundedRectangle(cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
          .strokeBorder((configuration.isPressed ? strokeColor?.highlight : strokeColor?.normal) ?? JCThemeColor.shared.clear, lineWidth: strokeColor == nil ? 0 : strokeWidth)
          .background(configuration.isPressed ? backgroundColor.highlight : backgroundColor.normal)
          .clipped())
        .foregroundColor(configuration.isPressed ? textColor.highlight : textColor.normal)
        .cornerRadius(cornerRadius, corners: .allCorners)
    }
  }

  // A fixed-size with gradient background style
  // see JCButtonStyles_Previews for examples
  struct GradientBackground: ButtonStyle {
    var width: CGFloat
    var height: CGFloat
    var textFont: Font = JCThemeFont.shared.L
    var textColor: JCColorPair = JCColorPair(normal: JCThemeColor.shared.buttonPrimaryText.normal,
                                             highlight: JCThemeColor.shared.buttonPrimaryText.highlight)
    var colors: [JCColorPair] = [JCColorPair(normal: Color.purple.opacity(0.7),
                                             highlight: Color.purple.opacity(0.9)),
                                 JCColorPair(normal: Color.blue.opacity(0.7),
                                             highlight: Color.blue.opacity(0.9))]
    var cornerRadius: CGFloat = 16

    public func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .font(textFont)
        .frame(width: width, height: height)
        .background(
          configuration.isPressed ?
            LinearGradient(colors: colors.map({ $0.highlight }), startPoint: .topLeading, endPoint: .bottomTrailing) :
            LinearGradient(colors: colors.map({ $0.normal }), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .foregroundColor(configuration.isPressed ? textColor.highlight : textColor.normal)
        .cornerRadius(cornerRadius, corners: .allCorners)
    }
  }

  struct HighlightStyle: ButtonStyle {
    var textFont: Font = JCThemeFont.shared.M
    var textColor: JCColorPair = JCColorPair(normal: JCThemeColor.shared.buttonPrimaryText.normal, highlight: JCThemeColor.shared.buttonPrimaryText.highlight)
    var backgroundColor: JCColorPair = JCColorPair(normal: JCThemeColor.shared.buttonSecondary.normal, highlight: JCThemeColor.shared.buttonSecondary.highlight)

    func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .font(textFont)
        .foregroundColor(configuration.isPressed ? textColor.highlight : textColor.normal)
        .background(configuration.isPressed ? backgroundColor.highlight : backgroundColor.normal)
    }
  }
}

// Just for examples
// make your own extension to fit in your project
private extension JCButtonStyle.FixedSizeRounded {
  static let main = JCButtonStyle.FixedSizeRounded(
    width: UIScreen.main.bounds.width - 60,
    height: 55
  )
  static let secondary = JCButtonStyle.FixedSizeRounded(
    width: UIScreen.main.bounds.width - 60,
    height: 55,
    textColor: JCThemeColor.shared.buttonSecondaryText,
    backgroundColor: JCThemeColor.shared.buttonSecondary,
    strokeColor: JCThemeColor.shared.buttonSecondaryBorder
  )
  static let loginButtonStyle = JCButtonStyle.FixedSizeRounded(
    width: 270,
    height: 52,
    textColor: JCColorPair(normal: .white, highlight: .white),
    backgroundColor: JCColorPair(normal: .yellow, highlight: .yellow.opacity(0.5)),
    strokeColor: JCColorPair(normal: .yellow, highlight: .orange)
  )

  static let regularButtonStyle = JCButtonStyle.FixedSizeRounded(
    width: 66,
    height: 40,
    cornerRadius: 8,
    textFont: JCThemeFont.shared.S,
    textColor: JCColorPair(normal: .white, highlight: .white),
    backgroundColor: JCColorPair(normal: .yellow, highlight: .yellow.opacity(0.5)),
    strokeColor: JCColorPair(normal: .yellow, highlight: .orange)
  )
}

struct JCButtonStyles_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      Button("RoundedCorner.main") {
        print("Button Clicked")
      }
      .buttonStyle(JCButtonStyle.FixedSizeRounded.main)

      Button("RoundedCorner.secondary") {
        print("Button Clicked")
      }
      .buttonStyle(JCButtonStyle.FixedSizeRounded.secondary)

      Button("Login") {
        print("Button Clicked")
      }
      .buttonStyle(JCButtonStyle.FixedSizeRounded.loginButtonStyle)

      // Small button needs suitable cornerRadius to avoid border issue, seems like a System bug
      let width: CGFloat = 44, height: CGFloat = 32
      HStack {
        Button("A small FixedSizeRounded") {
          print("Button Clicked")
        }.buttonStyle(JCButtonStyle.FixedSizeRounded(width: width, height: height, cornerRadius: 8))
        Button("A small FixedSizeRounded") {
          print("Button Clicked")
        }.buttonStyle(JCButtonStyle.FixedSizeRounded(width: width, height: height, cornerRadius: 10))
        Button("A small FixedSizeRounded") {
          print("Button Clicked")
        }.buttonStyle(JCButtonStyle.FixedSizeRounded(width: width, height: height, cornerRadius: 12))
        Button("A small FixedSizeRounded") {
          print("Button Clicked")
        }.buttonStyle(JCButtonStyle.FixedSizeRounded(width: width, height: height, cornerRadius: 14))
        Button("A small FixedSizeRounded") {
          print("Button Clicked")
        }.buttonStyle(JCButtonStyle.FixedSizeRounded(width: width, height: height, cornerRadius: 16))
        Button("A small FixedSizeRounded") {
          print("Button Clicked")
        }.buttonStyle(JCButtonStyle.FixedSizeRounded(width: width, height: height, cornerRadius: 18))
      }

      Button("GradientBackground") {
        print("Button Clicked")
      }
      .buttonStyle(JCButtonStyle.GradientBackground(width: 220, height: 44))

      HStack(spacing: 4) {
        Image(systemName: "pencil.circle")
        Text("Edit")
      }
      .buttonWrapped {
        print("Button Clicked")
      }
      .buttonStyle(JCButtonStyle.FixedSizeRounded.regularButtonStyle)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(JCThemeColor.shared.background)
  }
}
