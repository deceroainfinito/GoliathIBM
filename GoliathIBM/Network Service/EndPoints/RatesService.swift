//
//  NetworkService.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

class RatesService: NetworkService {

  static let shared = RatesService(router: Router<RateEndPoint>())

  let router: Router<RateEndPoint>

  init(router: Router<RateEndPoint>) {
    self.router = router
  }

  func fetchRates(completion: @escaping (Result<[Rate], NetworkError>) -> ()) {

    router.request(.allRates) { (data, response, error) in
      if error != nil {
        completion(.failure(NetworkError.requestError))
      } else {
        if let response = response as? HTTPURLResponse {
          let result = self.handleNetworkResponse(response)
          switch result {
          case .success:
            guard let responseData = data else {
              print("No data")
              completion(.failure(NetworkError.requestError))
              return
            }

            do {
              let rates = try JSONDecoder().decode([Rate].self, from: responseData)
              completion(.success(rates))
            } catch {
              print("Error Decoding")
              completion(.failure(NetworkError.requestError))
            }
          case .failure(let error):
            print(error.localizedDescription)
            completion(.failure(NetworkError.requestError))
          }
        }
      }
    }
  }
}
