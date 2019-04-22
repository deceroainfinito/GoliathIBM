//
//  TransactionsService.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

class TransactionService: NetworkService {

  static let shared = TransactionService(router: Router<TransactionsEndPoint>())

  let router: Router<TransactionsEndPoint>

  init(router: Router<TransactionsEndPoint>) {
    self.router = router
  }


  func fetchTransactions(completion: @escaping (Result<[Transaction], NetworkError>) -> ()) {

    router.request(.allTransactions) { (data, response, error) in
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
              let transactions = try JSONDecoder().decode([Transaction].self, from: responseData)
              completion(.success(transactions))
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
