//
//  Money.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

typealias Currency = String

struct Money: Equatable {
  var amount: Decimal
  var currency: Currency

  var rounded: Money {
    return self.rounded(scale: 2)
  }

  var description: String {
    return "\(amount) \(currency)"
  }

  var isEuro: Bool {
    return currency == "EUR"
  }

  func rounded(scale: Int = 2) -> Money {
    var approximate = self.amount
    var rounded = Decimal()

    NSDecimalRound(&rounded, &approximate, scale, .bankers)
    return Money(amount: rounded, currency: currency)
  }
}

extension Money {
  static func +(lhs: Money, rhs: Money) -> Money? {
    if lhs.currency == rhs.currency {
      return Money(amount: lhs.amount + rhs.amount, currency: lhs.currency)
    } else {
      return nil
    }
  }

  static func -(lhs: Money, rhs: Money) -> Money? {
    if lhs.currency == rhs.currency {
      return Money(amount: lhs.amount - rhs.amount, currency: lhs.currency)
    } else {
      return nil
    }
  }

  public static func *(lhs: Money, rhs: Decimal) -> Money {
    return Money(amount: lhs.amount * rhs, currency: lhs.currency)
  }

  public static func *(lhs: Money, rhs: Double) -> Money {
    return (lhs * Decimal(rhs)).rounded
  }
}
