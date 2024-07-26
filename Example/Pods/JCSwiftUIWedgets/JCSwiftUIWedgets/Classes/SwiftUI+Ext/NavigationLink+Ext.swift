//
//  NavigationLink+Ext.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2024-06-19.
//

import SwiftUI

public extension NavigationLink {
  init(isActive: Binding<Bool>?, @ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
    if let isActive = isActive {
      self.init(isActive: isActive, destination: destination, label: label)
    } else {
      self.init(destination: destination, label: label)
    }
  }
}
