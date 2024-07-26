//
//  Image+Ext.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2023-02-13.
//

import SwiftUI

public extension Image {
  func mask(color: Color) -> some View {
    renderingMode(.template).foregroundColor(color)
  }
    
  
}
