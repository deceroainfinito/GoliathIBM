//
//  TransactionViewModel.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

class TransactionViewModel {
  var transaction: Transaction
  var name: String
  lazy var conversion: String  = {
    if transaction.currency == "EUR" {
      return transaction.money.description
    } else {
      if let finalAmount = RatesUtil.shared.convert(money: transaction.money) {
        return transaction.money.description + " -> " + finalAmount.description
      } else {
        return transaction.money.description + " -> No conversion"
      }
    }
  }()

  init(transaction: Transaction) {
    self.transaction = transaction
    self.name = transaction.sku.capitalized
  }
}
