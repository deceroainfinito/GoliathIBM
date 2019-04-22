//
//  RateEndPoint.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

public enum RateEndPoint {
  case allRates
}

extension RateEndPoint: EndPointType {

  var environmentBaseURL : String {
    switch environment  {
      case .mobile: return "http://quiet-stone-2094.herokuapp.com"
      case .simulator: return "http://quiet-stone-2094.herokuapp.com"
    }
  }

  var baseURL: URL {
    guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL error") }
    return url
  }

  var path: String {
    switch self {
    case .allRates:
      return "rates"
    }
  }

  var httpMethod: HTTPMethod {
    return .get
  }

  var task: HTTPTask {
    switch self {
    case .allRates:
      return .requestParametersAndHeaders(bodyParameters: nil,
                                          bodyEnconding: .jsonEncoding,
                                          urlParameters: nil,
                                          additionHeaders: headers)
    }
  }

  var headers: HTTPHeaders? {
    return ["Accept": "application/json"]
  }
}
