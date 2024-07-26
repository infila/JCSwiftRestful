//
//  View+Ext.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2023/1/9.
//

import Combine
import SwiftUI

public extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }

  @ViewBuilder func navigationWrapped() -> some View {
    NavigationView {
      self
    }
  }

  @ViewBuilder func buttonWrapped(onClicked: @escaping () -> Void) -> some View {
    Button {
      onClicked()
    } label: {
      self
    }
  }

  @ViewBuilder func onValueChanged<T: Equatable>(_ value: T, onChange: @escaping (T) -> Void) -> some View {
    if #available(iOS 14.0, *) {
      self.onChange(of: value, perform: onChange)
    } else {
      onReceive(Just(value)) { value in
        onChange(value)
      }
    }
  }
}

private struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

#if DEBUG
  public extension View {
    func printFrame(in coordinateSpace: CoordinateSpace, withPrefixTag prefixTag: String? = nil) -> some View {
      modifier(GeoReaderModifier(coordinateSpace: coordinateSpace, prefixTag: prefixTag))
    }
  }

  private struct GeoReaderModifier: ViewModifier {
    var coordinateSpace: CoordinateSpace
    var prefixTag: String?
    @State var frame: GeometryProxy?

    @ViewBuilder
    func body(content: Content) -> some View {
      GeometryReader { geo in
        if #available(iOS 14.0, *) {
          content
            .onAppear {
              print("\(prefixTag ?? "Print Frame")(onAppear): \(geo.frame(in: coordinateSpace))")
            }.onChange(of: geo.frame(in: coordinateSpace)) { _ in
              print("\(prefixTag ?? "Print Frame")(onChange): \(geo.frame(in: coordinateSpace))")
            }
        }
      }
    }
  }

#endif


