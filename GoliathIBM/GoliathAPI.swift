//
//  GoliathAPI.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 25/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation
import Moya

enum GoliathAPI {
  case rates
  case transactions
}

extension GoliathAPI: TargetType {
  var baseURL: URL {
    return URL(string: "http://quiet-stone-2094.herokuapp.com")!
  }

  var path: String {
    switch self {
    case .rates:
      return "rates"
    case .transactions:
      return "transactions"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .rates, .transactions:
      return .requestPlain
    }
  }

  var headers: [String : String]? {
    return ["Accept": "application/json"]
  }
}
