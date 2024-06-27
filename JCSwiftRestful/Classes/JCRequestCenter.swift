//
//  JCRequestCenter.swift
//  JCSwiftRestful
//
//  Created by James Chen on 2022/11/01.
//

import Foundation
import JCSwiftCommon

public final class JCRequestCenter {
  public typealias ResponseOnSuccess = (_ requestData: JCRequestData, _ response: Data) -> Void
  public typealias ResponseOnApiError = (_ requestData: JCRequestData, _ apiError: JCRequestError) -> Void
  public typealias ResponseOnNetworkError = (_ requestData: JCRequestData, _ error: Error) -> Void
  public typealias RequestPackage = (requestData: JCRequestData,
                                     onSuccess: ResponseOnSuccess,
                                     onApiError: ResponseOnApiError,
                                     onNetworkError: ResponseOnNetworkError)

  public static let shared = JCRequestCenter()
  public var timeoutInterval: TimeInterval = 15
  public var domainUrl: String = ""
  public var invokeClosureOnMainThread = true
  public var consoleLogEnable = true
  public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

  public func sendRequest<T>(_ request: JCRequestData, completion: @escaping (Result<T, JCRequestError>) -> Void) where T: Codable {
    JCRequestCenter.shared.sendRequest(request) { _, response in
      if let model = JCSerialization.decode(from: response, decodeType: T.self) {
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

  public func sendRequest(_ request: JCRequestData, completion: @escaping (Result<Bool, JCRequestError>) -> Void) {
    JCRequestCenter.shared.sendRequest(request) { _, _ in
      completion(.success(true))
    } onApiError: { _, apiError in
      completion(.failure(apiError))
    } onNetworkError: { _, _ in
      completion(.failure(JCRequestError.NETWORK_ERROR))
    }
  }

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
      let urlPath = urlWithParameters(urlString, parameter: parameters)
    } else {
      body = JCRequestUtility.object2Data(request.parameter)
    }
    httpRequest(urlPath: urlPath, header: header, body: body, method: request.method) { response, data, error in
      if self.consoleLogEnable {
        print("JCRequestCenter: Receive from Url:\(urlString)" +
          (response == nil ? " statusCode: \(response!.statusCode)" : "statusCode: null") +
          (data == nil ? " data: \(String(data: data!, encoding: .utf8) ?? "")" : "data: null"))
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

  public func downloadFile(fileUrl: String, completion: @escaping (_ fileUrl: String, _ fileData: Data?) -> Void) {
    httpRequest(urlPath: fileUrl, header: nil, body: nil, method: .get) { request, data, error in
      var result: Data?
      if error == nil, request?.statusCode == 200 {
        result = data
      }
      completion(fileUrl, result)
    }
  }

  private init() {}

  private let operationQueue = OperationQueue()
  private var requestPackage401 = [RequestPackage]()
}

private extension JCRequestCenter {
  func urlString(request: JCRequestData) -> String {
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
        (header == nil ? " header: \(header!)" : "header: null") +
        (body == nil ? " body: \(String(data: body!, encoding: .utf8) ?? "")" : "body: null"))
    }

    let operation = BlockOperation {
      let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        completion(response as? HTTPURLResponse, data, error)
      }
      dataTask.resume()
    }
    operationQueue.addOperation(operation)
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

    if (200 ... 299).contains(response.statusCode) {
      if invokeClosureOnMainThread {
        Thread.mainThreadExecute {
          onSuccess(request, responseBody)
        }
      } else {
        onSuccess(request, responseBody)
      }
    } else if response.statusCode == 401 {
      requestPackage401.append((request, onSuccess, onApiError, onNetworkError))
      reauthenticate()
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

  func reauthenticate() {
  }

  func resendRequest401() {
    while !requestPackage401.isEmpty {
      if let requestPackage = requestPackage401.first {
        sendRequest(requestPackage.requestData,
                    onSuccess: requestPackage.onSuccess,
                    onApiError: requestPackage.onApiError,
                    onNetworkError: requestPackage.onNetworkError)
      }
      requestPackage401.removeFirst()
    }
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
