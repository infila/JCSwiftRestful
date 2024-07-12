//
//  JCRequestError.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2022/11/01.
//

import Foundation

public struct JCRequestError: Error, Codable {
  /// Incorrect URL string
  public static let URL_ERROR = JCRequestError(errorCode: 1000)
  /// Invalid network or timeout happened
  public static let NETWORK_ERROR = JCRequestError(errorCode: 1001)
  /// Cannot decode responseData from server
  public static let RESULT_JSON_ERROR = JCRequestError(errorCode: 1002)

  public var errorCode: Int
  public var reason: String?

  public static var errorCodeNameKey = "errorCode"
  public static var reasonNameKey = "reason"

  public var description: String {
    return "Error code: \(errorCode), \nReason: \(reason ?? "Unknown reason")"
  }
}

private extension JCRequestError {
  private enum CodingKeys: String, CodingKey {
    case errorCode
    case reason

    var rawValue: String {
      switch self {
      case .errorCode:
        return JCRequestError.errorCodeNameKey
      case .reason:
        return JCRequestError.reasonNameKey
      }
    }
  }
}
