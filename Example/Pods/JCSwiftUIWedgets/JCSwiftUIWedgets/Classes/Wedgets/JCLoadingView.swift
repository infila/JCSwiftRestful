//
//  JCLoadingView.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2022/12/12.
//

import SwiftUI

extension View {
  func showLoading(_ loading: Bool) -> some View {
    modifier(JCLoadingViewModifier(isPresented: loading))
  }
}

struct JCLoadingViewModifier: ViewModifier {
  var isPresented: Bool

  @ViewBuilder
  func body(content: Content) -> some View {
    ZStack {
      content.disabled(isPresented)
      if isPresented {
        JCLoadingView()
      }
    }
  }
}

enum JCLoadingSpin {
  case image(Image)
  case circle(trimEnd: CGFloat, lineWidth: CGFloat, strokeColor: Color, diameter: CGFloat)
}

// Editing config.shared ensures that this component looks the same wherever it is used.
// Or have a new Config() to make it special.
public struct JCLoadingViewConfig {
  static let shared = JCLoadingViewConfig()

  var backgroundColor = Color.gray.opacity(0.4)
  var spin: JCLoadingSpin = JCLoadingSpin.circle(trimEnd: 0.6, lineWidth: 4, strokeColor: JCThemeColor.shared.success, diameter: 50)
}

public struct JCLoadingView: View {
  var config: JCLoadingViewConfig = JCLoadingViewConfig.shared

  public var body: some View {
    GeometryReader { geo in
      ZStack {
        config.backgroundColor
          .edgesIgnoringSafeArea(.all)

        if isAppeared {
          switch config.spin {
          case let .image(image):
            image.rotationEffect(.degrees(isRotated ? 360 : 0))
              .animation(.linear(duration: 1).repeatForever(autoreverses: false))
              .onAppear {
                isRotated = true
              }
          case let .circle(trimEnd, lineWidth, strokeColor, diameter):
            Circle()
              .trim(from: 0, to: trimEnd)
              .stroke(
                strokeColor,
                lineWidth: lineWidth
              )
              .frame(width: diameter, height: diameter)
              .rotationEffect(.degrees(isRotated ? 360 : 0))
              .animation(.linear(duration: 1).repeatForever(autoreverses: false))
              .onAppear {
                isRotated = true
              }
          }
        }
      }
      .onAppear {
        if geo.size != .zero {
          isAppeared = true
        }
      }
      .onValueChanged(geo.frame(in: .global)) { _ in
        isAppeared = true
      }
    }
  }

  @State internal var isAppeared = false
  @State internal var isRotated = false
}

#Preview {
//      JCLoadingView(config: JCLoadingViewConfig(spin:.image(Image(systemName: "arrowshape.forward")) ))

  // set true to stop animation, otherwise CPU is pretty hot
  JCLoadingView(isAppeared: true, isRotated: true)
}
