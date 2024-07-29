//
//  IpHistoryView.swift
//  JCSwiftRestful_Example
//
//  Created by James Chen on 2024-07-29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftUIWedgets
import SwiftUI

struct IpHistoryCell: View {
  @State var date: String
  @State var ip: String

  var body: some View {
    HStack {
      Text(date)
        .foregroundColor(JCThemeColor.shared.textSecondary)
        .padding()
      Spacer()
      Text(ip)
        .foregroundColor(JCThemeColor.shared.textPrimary)
        .font(JCThemeFont.shared.L)
        .padding()
    }
  }
}

struct IpHistoryView: View {
  @State var historyEntities: [IpEntity] = []

  var body: some View {
    VStack {
      ForEach(historyEntities, id: \.dateString) { entity in
        IpHistoryCell(date: entity.dateString, ip: entity.IP)
      }
      Spacer()
      HStack {
        Image(systemName: "trash")
        Text("Delete")
      }.buttonWrapped {
        IpEntity.clear()
        historyEntities = [IpEntity].load()
      }.buttonStyle(MyButtonStyle.delete)
    }.onAppear {
      historyEntities = [IpEntity].load()
    }
  }
}

#Preview {
  IpHistoryView()
}
