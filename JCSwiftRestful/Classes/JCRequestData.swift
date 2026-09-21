//
//  JCRequestData.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2022/11/01.
//

import Foundation

public enum JCHttpMethod: String {
  case get
  case post
  case put
  case patch
  case delete
}

/// Encapsulating an API request into an object is a good habit.
/// This helps you focus on one thing at one time, and pretty easy for doing maintenance.
public protocol JCRequestData {
  var apiPath: String { get }
  var method: JCHttpMethod { get }
  var header: [String: String] { get }
  var parameter: Codable? { get }
}
