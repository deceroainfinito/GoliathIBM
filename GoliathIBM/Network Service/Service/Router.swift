//
//  NetworkRouter.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()

private protocol NetworkRouter: class {
  associatedtype EndPoint: EndPointType
  var session: URLSession { get }
  func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
  func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
  private var task: URLSessionTask?
  fileprivate let session: URLSession

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
    do {
      let request = try self.buildRequest(from: route)
      NetworkLogger.log(request: request)
      task = session.dataTask(with: request, completionHandler: { data, response, error in
        completion(data, response, error)
      })
    }catch {
      completion(nil, nil, error)
    }
    self.task?.resume()
  }

  func cancel() {
    self.task?.cancel()
  }

  fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {

    var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                             timeoutInterval: 10.0)

    request.httpMethod = route.httpMethod.rawValue
    do {
      switch route.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case .requestParameters(let bodyParameters,
                              let bodyEncoding,
                              let urlParameters):

        try self.configureParameters(bodyParameters: bodyParameters,
                                     bodyEncoding: bodyEncoding,
                                     urlParameters: urlParameters,
                                     request: &request)

      case .requestParametersAndHeaders(let bodyParameters,
                                        let bodyEncoding,
                                        let urlParameters,
                                        let additionalHeaders):

        self.addAdditionalHeaders(additionalHeaders, request: &request)
        try self.configureParameters(bodyParameters: bodyParameters,
                                     bodyEncoding: bodyEncoding,
                                     urlParameters: urlParameters,
                                     request: &request)
      }
      return request
    } catch {
      throw error
    }
  }

  fileprivate func configureParameters(bodyParameters: Parameters?,
                                       bodyEncoding: ParameterEncoding,
                                       urlParameters: Parameters?,
                                       request: inout URLRequest) throws {
    do {
      try bodyEncoding.encode(urlRequest: &request,
                              bodyParameters: bodyParameters, urlParameters: urlParameters)
    } catch {
      throw error
    }
  }

  fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
    guard let headers = additionalHeaders else { return }
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
  }

}
