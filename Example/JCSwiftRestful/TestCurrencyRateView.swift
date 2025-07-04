//
//  TestCurrencyRateView.swift
//  JCSwiftRestful_Example
//
//  Created by James Chen on 2024-07-26.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftCommon
import JCSwiftRestful
import JCSwiftUIWedgets
import SwiftUI

struct ExchangeRateEntity: JCPersistentObject {
  func persistentId() -> String {
    return dateString
  }

  init(date: Date, rate: Double) {
    dateString = date.format2String(Date.FormatStyle.y4m2d2Dash + " " + Date.FormatStyle.H2m2s2)
    self.rate = rate
  }

  var dateString: String
  var rate: Double
}

struct TestCurrencyRateView: View {
  @State var rate: Double?
  @State var lastIp: String?

  var body: some View {
    VStack {
      HStack {
        Spacer()
        NavigationLink {
          RateHistoryView()
        } label: {
          Image(systemName: "clock").padding()
        }
      }

      VStack(spacing: 30) {
        Text("Current USD to CAD exchange rate is: \(rate ?? 0)")
          .foregroundColor(rate == nil ? .gray : .black)
          .font(JCThemeFont.L)

        Button("Query") {
          Task {
            // Get from Server
            let result = try? await JCRequestCenter.shared.sendRequest(CurrencyTestRequestData(), decodeType: CurrencyTestRequestData.Response.self)
            rate = result?.rates["CAD"]

            // Save to local
            if let rate = rate {
              let entity = ExchangeRateEntity(date: Date(), rate: rate)
              entity.save()
            }
          }
        }.buttonStyle(MyButtonStyle.regular)

        Text("Send Request")
          .buttonWrapped {
            sendRequest()
          }
          .buttonStyle(JCButtonStyle.FixedSizeRounded(width: 160, height: 44))
//          .hidden()

      }.frame(maxHeight: .infinity)
    }.navigationWrapped()
  }

  func sendRequest() {
    Task {
      let result = try? await JCRequestCenter.shared.sendRequest(GetUserInfoRequestData(), decodeType: GetUserInfoRequestData.Response.self)
      print(JCSerialization.objectToDict(result))
    }
  }
}

#Preview {
  TestCurrencyRateView()
}
