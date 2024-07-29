//
//  TestIpView.swift
//  JCSwiftRestful_Example
//
//  Created by James Chen on 2024-07-26.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import JCSwiftCommon
import JCSwiftRestful
import JCSwiftUIWedgets
import SwiftUI

private struct IpTestRequestData: JCRequestData {
  struct Response: Codable {
    var ip: String
  }

  var apiPath: String {
    "http://ip.jsontest.com"
  }
}

struct IpEntity: JCPersistentObject {
  func persistentId() -> String {
    return dateString
  }

  init(date: Date, IP: String) {
    dateString = date.format2String(Date.FormatStyle.y4m2d2Dash + " " + Date.FormatStyle.H2m2s2)
    self.IP = IP
  }

  var dateString: String
  var IP: String
}

struct TestIpView: View {
  @State var ipString: String?
  @State var lastIp: String?

  var body: some View {
    VStack {
      HStack {
        Spacer()
        NavigationLink {
          IpHistoryView()
        } label: {
          Image(systemName: "clock").padding()
        }
      }

      VStack(spacing: 30) {
        Text(ipString ?? "Your current IP is:")
          .foregroundColor(ipString == nil ? .gray : .black)
          .font(JCThemeFont.shared.L)

        Button("Query") {
          Task {
            // Get from Server
            let result = try? await JCRequestCenter.shared.sendRequest(IpTestRequestData(), decodeType: IpTestRequestData.Response.self)
            ipString = result?.ip

            // Save to local
            if let ipString = ipString {
              let entity = IpEntity(date: Date(), IP: ipString)
              entity.save()
            }
          }
        }.buttonStyle(MyButtonStyle.regular)
      }.frame(maxHeight: .infinity)
    }.navigationWrapped()
  }
}

#Preview {
  TestIpView()
}
