//
//  Extensions.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

extension Array where Element == Transaction {
  func unique() -> [Element] {
    return reduce([], { (result, outEle) -> [Element] in
      return result.contains(where: { (innerEle) -> Bool in
        return innerEle ~= outEle
      }) ? result : result + [outEle]
    })
  }

  mutating func uniqued() {
    self = self.unique()
  }
}

extension Array where Element == Money {
  func sumWithRateUtil(_ rateUtil: RatesUtil) -> Money? {
    let convertedMoney = map { (money) -> Money? in
      rateUtil.convert(money: money)
    }

    if convertedMoney.contains(nil) {
      return nil
    } else {
      return convertedMoney.reduce(Money(amount: 0.0, currency: "EUR")) { (result, money) -> Money in
        return (result + money!)!
      }
    }
  }
}

extension Array where Element == String {
  func unique() -> [Element] {
    var uniqueValues = [Element: Bool]()

    return filter {
      uniqueValues.updateValue(true, forKey: $0) == nil
    }
  }

  mutating func uniqued() {
    self = self.unique()
  }
}

extension Double {
  func bankRound() -> Int {
    return lrint(self)
  }
}
