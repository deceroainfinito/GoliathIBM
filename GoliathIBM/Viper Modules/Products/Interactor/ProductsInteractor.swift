//
//  ProductsInteractor.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 26/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation
import Moya

protocol ProductsInteractorInputProtocol {
  func fetchRates()
  func fetchTransactions()
}

protocol ProductsInteractorOutputProtocol {
  func products(_ products: [TransactionViewModel])
}

class ProductsInteractor: NSObject, ProductsInteractorInputProtocol {

  var output: ProductsInteractorOutputProtocol!
  var networkService: MoyaProvider<GoliathAPI>!

  func fetchRates() {
    networkService.request(.rates) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let ratesResponse):
        DispatchQueue.global(qos: .utility).async {
          do {
            let parsedRates = try ratesResponse.map([Rate].self)
            try StorageManager.storeRates(parsedRates)
          } catch {
            print(error.localizedDescription)
          }
        }
      }
    }
  }

  func fetchTransactions() {
    networkService.request(.transactions) { [unowned self] (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let tranResponse):
        do {
          let transactions = try tranResponse.map([Transaction].self)
          DispatchQueue.global(qos: .utility).async {
            try! StorageManager.storeTransactions(transactions)
          }

          let transactionsViewModel = transactions.unique().map({ TransactionViewModel(transaction: $0) })

          self.output.products(transactionsViewModel)

        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
}
