//
//  Transaction.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

struct Transaction: Codable, Equatable, Hashable {
  let sku: String
  let amount: String
  let currency: String

  var money: Money {
    return Money(amount: Decimal(string: amount)!, currency: currency).rounded
  }
}

extension Transaction {
  static func ~=(lhs: Transaction, rhs: Transaction) -> Bool {
    return lhs.sku == rhs.sku
  }
}
