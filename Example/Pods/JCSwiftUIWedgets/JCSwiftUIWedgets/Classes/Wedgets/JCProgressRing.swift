//
//  JCProgressRing.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2024-07-24.
//

import SwiftUI

enum JCProgressRingStartPosition {
  case top
  case bottom
  case left
  case right
}

// Editing config.shared ensures that this component looks the same wherever it is used,
// Or have a new Config() to make it special.
public struct JCProgressRingConfig {
  static let shared = JCProgressRingConfig()

  var width: CGFloat = 100
  var ringWidth: CGFloat = 12
  var ringColor: Color = JCThemeColor.shared.primary

  var start: JCProgressRingStartPosition = .top
}

public struct JCProgressRing: View {
  @State var percent: CGFloat

  var config = JCProgressRingConfig.shared

  public var body: some View {
    ZStack {
      Circle()
        .trim(to: percent)
        .stroke(
          config.ringColor,
          lineWidth: config.ringWidth
        )
        .frame(width: config.width - config.ringWidth, height: config.width - config.ringWidth)
        .rotationEffect(.degrees(degress()))
        .shadow(radius: 2)
    }.frame(width: config.width, height: config.width)
  }

  private func degress() -> Double {
    switch config.start {
    case .top:
      return 270
    case .bottom:
      return 90
    case .left:
      return 180
    case .right:
      return 0
    }
  }
}

#Preview {
  VStack {
    JCProgressRing(percent: 0.3)
    JCProgressRing(percent: 0.9, config: JCProgressRingConfig(width: 100, ringWidth: 50, start: .bottom))
    ZStack {
      JCProgressRing(percent: 0.4, config: JCProgressRingConfig(width: 52, ringColor: Color.orange))
      JCProgressRing(percent: 0.3, config: JCProgressRingConfig(width: 76, ringColor: Color.red))
      JCProgressRing(percent: 0.6, config: JCProgressRingConfig(width: 100, ringColor: Color.green))
      JCProgressRing(percent: 0.4, config: JCProgressRingConfig(width: 124, ringColor: Color.blue))
    }
  }
}
