//
//  RateHistoryView.swift
//  JCSwiftRestful_Example
//
//  Created by James Chen on 2024-07-29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftUIWedgets
import SwiftUI

struct RateHistoryCell: View {
  @State var date: String
  @State var rate: Double

  var body: some View {
    HStack {
      Text(date)
        .foregroundColor(JCThemeColor.textSecondary)
        .padding()
      Spacer()
      Text(String(rate))
        .foregroundColor(JCThemeColor.textPrimary)
        .font(JCThemeFont.L)
        .padding()
    }
  }
}

struct RateHistoryView: View {
  @State var historyEntities: [ExchangeRateEntity] = []

  var body: some View {
    VStack {
      ForEach(historyEntities, id: \.dateString) { entity in
        RateHistoryCell(date: entity.dateString, rate: entity.rate)
      }
      Spacer()
      HStack {
        Image(systemName: "trash")
        Text("Delete")
      }.buttonWrapped {
        ExchangeRateEntity.clear()
        historyEntities = [ExchangeRateEntity].load()
      }.buttonStyle(MyButtonStyle.delete)
    }.onAppear {
      historyEntities = [ExchangeRateEntity].load()
    }
  }
}

#Preview {
  RateHistoryView()
}
