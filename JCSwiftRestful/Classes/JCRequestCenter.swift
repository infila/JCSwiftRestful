//
//  JCRequestCenter.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2022/11/01.
//

import Foundation
import JCSwiftCommon

/// API Requst Center, Singleton
public final class JCRequestCenter {
  public typealias ResponsePacket = (reqeustData: JCRequestData, data: Data?, error: Error?)

  public static let shared = JCRequestCenter()
  public var timeoutInterval: TimeInterval = 15

  /// if (JCRequestData.apiPath.starts(with: "http")), { url = JCRequestData.apiPath }
  /// else { url = domainUrl + JCRequestData.apiPath }
  public var domainUrl: String = ""

  public var consoleLogEnable = true
  public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  public var successStatusCode = (200 ... 299)
  public var specialHandler: [(condition: (_ statusCode: Int, _ error: JCRequestError) -> Bool,
                               completion: (_ requestData: JCRequestData) -> ResponsePacket)] = []

  /// Will be called before send request. Do any encryption processing if you like.
  public var encryptClosure: ((Data) -> (Data))?
  /// Will be called after get requestData. If the data encrpted at server side, don't forget decrypt it.
  public var decryptClosure: ((Data) -> (Data))?

  public func sendRequest<T>(_ request: JCRequestData, decodeType: T.Type) async throws -> T where T: Codable {
    let result = await JCRequestCenter.shared.sendRequest(request)
    if let error = result.2 as? JCRequestError {
      throw error
    } else if let responseData = result.1 {
      if decodeType == Bool.self {
        return true as! T
      }
      if let model = JCSerialization.decode(from: responseData, decodeType: T.self) {
        return model
      } else {
        throw JCRequestError.RESULT_JSON_ERROR
      }
    } else {
      throw JCRequestError.NETWORK_ERROR
    }
  }

  public func sendRequest(_ request: JCRequestData) async -> ResponsePacket {
    let urlString = self.urlString(request: request).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let header = request.header
    var urlPath = urlString
    var body: Data?
    if request.method == .get {
      let parameters = JCRequestUtility.object2UrlParameters(request.parameter)
      urlPath = urlWithParameters(urlString, parameter: parameters)
    } else {
      body = JCRequestUtility.object2Data(request.parameter)
      if body != nil, let encryptClosure = encryptClosure {
        body = encryptClosure(body!)
      }
    }
    let result: (response: HTTPURLResponse?, data: Data?, error: Error?) = await httpRequest(urlPath: urlPath, header: header, body: body, method: request.method)
    if consoleLogEnable {
      print("JCRequestCenter: Receive from Url:\(urlString)" +
        (result.response != nil ? " statusCode: \(result.response!.statusCode)" : "statusCode: null") +
        (result.data != nil ? " data: \(String(data: result.data!, encoding: .utf8) ?? "")" : "data: null"))
    }
    return handleResponse(request: request,
                          response: result.response,
                          responseBody: result.data,
                          error: result.error)
  }

  private init() {}

  private let operationQueue = OperationQueue()
}

private extension JCRequestCenter {
  func urlString(request: JCRequestData) -> String {
    if request.apiPath.starts(with: "http") {
      return request.apiPath
    }
    return domainUrl + request.apiPath
  }

  func httpRequest(urlPath: String,
                   header: [String: String]?,
                   body: Data?,
                   method: JCHttpMethod) async -> (HTTPURLResponse?, Data?, Error?) {
    guard let url = URL(string: urlPath) else {
      if consoleLogEnable {
        print("JCRequestCenter: Invalid URL: \(urlPath)")
      }
      return (nil, nil, JCRequestError.URL_ERROR)
    }

    var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    urlRequest.httpMethod = method.rawValue
    urlRequest.allHTTPHeaderFields = header
    urlRequest.httpBody = body

    if consoleLogEnable {
      print("JCRequestCenter: sending to Url:\(url) method: \(method.rawValue)" +
        (header != nil ? " header: \(header!)" : "header: null") +
        (body != nil ? " body: \(String(data: body!, encoding: .utf8) ?? "")" : "body : null"))
    }

    do {
      let result = try await URLSession.shared.data(for: urlRequest)
      return (result.1 as? HTTPURLResponse, result.0, nil)
    } catch {
      return (nil, nil, error)
    }
  }

  func handleResponse(request: JCRequestData,
                      response: HTTPURLResponse?,
                      responseBody: Data?,
                      error: Error?) -> ResponsePacket {
    var result: ResponsePacket = (request, nil, nil)
    guard let response = response, let responseBody = responseBody, error == nil else {
      result.error = URLError(.badServerResponse)
      return result
    }

    if successStatusCode.contains(response.statusCode) {
      if let decryptClosure = decryptClosure, let data = result.data {
        result.data = decryptClosure(data)
      } else {
        result.data = responseBody
      }
    } else {
      let apiError = JCSerialization.decode(from: responseBody, decodeType: JCRequestError.self) ?? JCRequestError(errorCode: response.statusCode, reason: String(data: responseBody, encoding: .utf8))
      for (condition, completion) in specialHandler {
        if condition(response.statusCode, apiError) {
          return completion(request)
        }
      }
      result.error = apiError
    }
    return result
  }

  func urlWithParameters(_ urlString: String, parameter: [String: String]?) -> String {
    guard let parameter = parameter, parameter.count > 0 else {
      return urlString
    }
    var result = urlString
    if !urlString.contains("?") {
      result += "?"
    }
    var needAnd = result.contains("=")
    for (key, value) in parameter {
      if needAnd {
        result += "&"
      }
      result += key + "=" + value
      needAnd = true
    }
    return result
  }
}
