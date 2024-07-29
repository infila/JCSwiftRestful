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
  public typealias ResponseOnSuccess = (_ requestData: JCRequestData, _ response: Data) -> Void
  public typealias ResponseOnApiError = (_ requestData: JCRequestData, _ apiError: JCRequestError) -> Void
  public typealias ResponseOnNetworkError = (_ requestData: JCRequestData, _ error: Error) -> Void

  public static let shared = JCRequestCenter()
  public var timeoutInterval: TimeInterval = 15
  /// Full path url = domainUrl + JCRequestData.apiPath
  /// Set domainUrl like "www.x.com" and (some JCRequestData).apiPath = "/i/flow/password_reset" is recommanded
  public var domainUrl: String = ""
  /// Any Callback after getting Response from server, like ResponseOnSuccess(), will invoked on main thread
  /// if invokeClosureOnMainThread = true.
  /// So that it's safe for you to update UI in those closures.
  /// NO effect on async functions
  public var invokeClosureOnMainThread = true
  public var consoleLogEnable = true
  public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  public var successStatusCode = (200 ... 299)

  /// Will be called before send request. Do any encryption processing if you like.
  public var encryptClosure: ((Data) -> (Data))?
  /// Will be called after get requestData. If the data encrpted at server side, don't forget decrypt it.
  public var decryptClosure: ((Data) -> (Data))?

  /// Send (some JCRequestData) and get (some Codable) as call back
  /// Usually used while get informations from server side
  public func sendRequest<T>(_ request: JCRequestData, completion: @escaping (Result<T, JCRequestError>) -> Void) where T: Codable {
    JCRequestCenter.shared.sendRequest(request) { _, response in
      var responseData: Data
      if let decryptClosure = self.decryptClosure {
        responseData = decryptClosure(response)
      } else {
        responseData = response
      }
      if let model = JCSerialization.decode(from: responseData, decodeType: T.self) {
        completion(.success(model))
      } else {
        completion(.failure(JCRequestError.RESULT_JSON_ERROR))
      }
    } onApiError: { _, apiError in
      completion(.failure(apiError))
    } onNetworkError: { _, _ in
      completion(.failure(JCRequestError.NETWORK_ERROR))
    }
  }

  public func sendRequest<T>(_ request: JCRequestData, decodeType: T.Type) async throws -> T where T: Codable {
    let result = await JCRequestCenter.shared.sendRequest(request)
    if let error = result.2 as? JCRequestError {
      throw error
    } else if var responseData = result.1 {
      if decodeType == Bool.self {
        return true as! T
      }
      if let decryptClosure = decryptClosure {
        responseData = decryptClosure(responseData)
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

  /// Send (some JCRequestData) and get a Bool as call back
  /// Usually used while update or upload something to server side
  public func sendRequest(_ request: JCRequestData, completion: @escaping (Result<Bool, JCRequestError>) -> Void) {
    JCRequestCenter.shared.sendRequest(request) { _, _ in
      completion(.success(true))
    } onApiError: { _, apiError in
      completion(.failure(apiError))
    } onNetworkError: { _, _ in
      completion(.failure(JCRequestError.NETWORK_ERROR))
    }
  }

  /// If the other two sendRequest() methods is not suitable in your case, this helps
  public func sendRequest(_ request: JCRequestData,
                          onSuccess: @escaping (_ requestData: JCRequestData, _ response: Data) -> Void,
                          onApiError: @escaping (_ requestData: JCRequestData, _ apiError: JCRequestError) -> Void,
                          onNetworkError: @escaping (_ requestData: JCRequestData, _ error: Error) -> Void) {
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
    httpRequest(urlPath: urlPath, header: header, body: body, method: request.method) { response, data, error in
      if self.consoleLogEnable {
        print("JCRequestCenter: Receive from Url:\(urlString)" +
          (response != nil ? " statusCode: \(response!.statusCode)" : "statusCode: null") +
          (data != nil ? " data: \(String(data: data!, encoding: .utf8) ?? "")" : "data: null"))
      }
      self.handleResponse(request: request,
                          response: response,
                          responseBody: data,
                          error: error,
                          onSuccess: onSuccess,
                          onApiError: onApiError,
                          onNetworkError: onNetworkError)
    }
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
                   method: JCHttpMethod,
                   completion: @escaping (_ response: HTTPURLResponse?, _ responseBody: Data?, _ error: Error?) -> Void) {
    guard let url = URL(string: urlPath) else {
      if consoleLogEnable {
        print("JCRequestCenter: Invalid URL: \(urlPath)")
      }

      completion(nil, nil, JCRequestError.URL_ERROR)
      return
    }

    var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    urlRequest.httpMethod = method.rawValue
    urlRequest.allHTTPHeaderFields = header
    urlRequest.httpBody = body

    if consoleLogEnable {
      print("JCRequestCenter: sending to Url:\(url) method: \(method.rawValue)" +
        (header != nil ? " header: \(header!)" : "header: null") +
        (body != nil ? " body: \(String(data: body!, encoding: .utf8) ?? "")" : "body: null"))
    }

    let operation = BlockOperation {
      let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        completion(response as? HTTPURLResponse, data, error)
      }
      dataTask.resume()
    }
    operationQueue.addOperation(operation)
  }

  func sendRequest(_ request: JCRequestData) async -> (JCRequestData, Data?, Error?) {
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
                      error: Error?,
                      onSuccess: @escaping ResponseOnSuccess,
                      onApiError: @escaping ResponseOnApiError,
                      onNetworkError: @escaping ResponseOnNetworkError) {
    guard let response = response, let responseBody = responseBody, error == nil else {
      if invokeClosureOnMainThread {
        Thread.mainThreadExecute {
          onNetworkError(request, error ?? URLError(.badServerResponse))
        }
      } else {
        onNetworkError(request, error ?? URLError(.badServerResponse))
      }
      return
    }

    if successStatusCode.contains(response.statusCode) {
      if invokeClosureOnMainThread {
        Thread.mainThreadExecute {
          onSuccess(request, responseBody)
        }
      } else {
        onSuccess(request, responseBody)
      }
    } else {
      if let apiError = JCSerialization.decode(from: responseBody, decodeType: JCRequestError.self) {
        if invokeClosureOnMainThread {
          Thread.mainThreadExecute {
            onApiError(request, JCRequestError(errorCode: apiError.errorCode, reason: apiError.reason))
          }
        } else {
          onApiError(request, JCRequestError(errorCode: apiError.errorCode, reason: apiError.reason))
        }
      } else {
        if invokeClosureOnMainThread {
          Thread.mainThreadExecute {
            onApiError(request, JCRequestError(errorCode: response.statusCode, reason: String(data: responseBody, encoding: .utf8)))
          }
        } else {
          onApiError(request, JCRequestError(errorCode: response.statusCode, reason: String(data: responseBody, encoding: .utf8)))
        }
      }
    }
  }

  func handleResponse(request: JCRequestData,
                      response: HTTPURLResponse?,
                      responseBody: Data?,
                      error: Error?) -> (JCRequestData, Data?, Error?) {
    var result: (request: JCRequestData, responseData: Data?, error: Error?) = (request, nil, nil)
    guard let response = response, let responseBody = responseBody, error == nil else {
      result.error = URLError(.badServerResponse)
      return result
    }

    if (200 ... 299).contains(response.statusCode) {
      result.responseData = responseBody
      result.error = nil
    } else {
      if let apiError = JCSerialization.decode(from: responseBody, decodeType: JCRequestError.self) {
        result.responseData = nil
        result.error = JCRequestError(errorCode: apiError.errorCode, reason: apiError.reason)
      } else {
        result.responseData = nil
        result.error = JCRequestError(errorCode: response.statusCode, reason: String(data: responseBody, encoding: .utf8))
      }
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
