//
//  TransactionsEndPoint.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

public enum TransactionsEndPoint {
  case allTransactions
}

extension TransactionsEndPoint: EndPointType {

  var environmentBaseURL : String {
    switch environment  {
      case .mobile: return "http://quiet-stone-2094.herokuapp.com"
      case .simulator: return "http://quiet-stone-2094.herokuapp.com"
    }
  }


  var baseURL: URL {
    guard let url = URL(string: environmentBaseURL) else { fatalError("Bad baseURL") }
    return url
  }

  var path: String {
    switch self {
    case .allTransactions:
      return "transactions"
    }
  }

  var httpMethod: HTTPMethod {
    return .get
  }

  var task: HTTPTask {
    switch self {
    case .allTransactions:
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

