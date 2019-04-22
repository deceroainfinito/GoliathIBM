//
//  NetworkService.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

enum NetworkServiceEnvironment {
  case simulator
  case mobile
}

protocol NetworkService {
  associatedtype RouterType: EndPointType

  var router: Router<RouterType> { get }
}

extension NetworkService {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Void?, NetworkResponseError> {
    switch response.statusCode {
    case 200...299: return .success(nil)
    case 401...500: return .failure(NetworkResponseError.authenticationError)
    case 501...599: return .failure(NetworkResponseError.badRequest)
    case 600: return .failure(NetworkResponseError.outdated)
    default: return .failure(NetworkResponseError.failed)
    }
  }
}
