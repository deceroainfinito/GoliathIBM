//
//  RatesUtil.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

func permuteWirth<T>(_ a: [T], _ n: Int, _ result: inout [[T]]) {
  if n == 0 {
//    print(a)   // display the current permutation
    result.append(a)
  } else {
    var a = a
    permuteWirth(a, n - 1, &result)
    for i in 0..<n {
      a.swapAt(i, n)
      permuteWirth(a, n - 1, &result)
      a.swapAt(i, n)
    }
  }
}

struct RatesUtil {

  static let shared = RatesUtil(rates: try! StorageManager.loadRates())

  private let rates: [Rate]
  private let currencies: [String]
  private var pairs: Dictionary = [String: Double]()

  private var permutations = [[String]]()

  init(rates: [Rate]) {
    self.rates = rates
    self.currencies = rates.map({ $0.from }).unique()
    permuteWirth(currencies, currencies.count - 1, &permutations)
    rates.forEach { (rate) in
      pairs["\(rate.from)|\(rate.to)"] = Double(rate.rate)
    }
  }

  func convert(money: Money, to destCurrency: Currency = "EUR") -> Money? {
    if money.currency == destCurrency { return money.rounded }

    let directRate: [Rate]
    var complexRates: [[String]]? = [[String]]()
    var rate = 1.0

    directRate = rates.filter { (rate) -> Bool in
      return rate.from == money.currency && rate.to == destCurrency
    }

    if directRate.isEmpty {
      complexRates = permutations.filter { (path) -> Bool in
        return path.first == money.currency && path.last == destCurrency
      }

      if let complexRates = complexRates {
        for path in complexRates {
          for (index, _) in path.enumerated() {
            if index + 1 <= path.count - 1 {
              if let nextRate = pairs["\(path[index])|\(path[index + 1])"] {
                rate *= nextRate
              }
            }
          }
        }
      }
    } else {
      complexRates = nil
      rate *= Double(directRate.first!.rate)!
    }

    let convertedMoney = (Money(amount: money.amount, currency: "EUR") * rate).rounded

    if rate == 1.0 {
      print(money.description)
      return nil
    }

    return convertedMoney
  }
}

