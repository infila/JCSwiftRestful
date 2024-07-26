//
//  JCToggle.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2022/12/23.
//

import SwiftUI

// Editing config.shared ensures that this component looks the same wherever it is used.
// Or have a new Config() to make it special.
public struct JCToggleConfig {
  static let shared = JCToggleConfig()

  var width: CGFloat = 52
  var height: CGFloat = 32

  var backgroundColor = JCColorPair(normal: JCThemeColor.shared.separateLine, highlight: JCThemeColor.shared.success.opacity(0.3))
  var foregroundColor = JCColorPair(normal: JCThemeColor.shared.navigationBar, highlight: JCThemeColor.shared.success)

  var thumbHeight: CGFloat = 24
  var thumbOffset: CGFloat = 10
}

public struct JCToggle: View {
  var tintColor: Color = JCThemeColor.shared.primary
  @Binding var isOn: Bool
  var onChange: ((Bool) -> Void)?

  var config = JCToggleConfig.shared

  public var body: some View {
    ZStack {
      Capsule()
        .fill(isOn ? config.backgroundColor.highlight : config.backgroundColor.normal)

      Circle()
        .fill(isOn ? config.foregroundColor.highlight : config.foregroundColor.normal)
        .frame(height: config.thumbHeight)
        .offset(x: isOn ? config.thumbOffset : -config.thumbOffset)
    }
    .frame(width: config.width, height: config.height)
    .onTapGesture {
      withAnimation {
        isOn.toggle()
      }
      onChange?(isOn)
    }
  }
}

#Preview {
  VStack {
    JCToggle(isOn: .constant(false))
    JCToggle(isOn: .constant(true))
  }
}
