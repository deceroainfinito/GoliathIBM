//
//  RatesUtilTests.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
@testable import GoliathIBM

class RatesUtilTests: XCTestCase {

  var rates1: [Rate]!

  var rateUtil: RatesUtil!

  override func setUp() {
    rates1 = [
      Rate(from: "EUR", to: "USD", rate: "1.359"),
      Rate(from: "CAD", to: "EUR", rate: "0.732"),
      Rate(from: "USD", to: "EUR", rate: "0.736"),
      Rate(from: "EUR", to: "CAD", rate: "1.366")
    ]

    rateUtil = RatesUtil(rates: rates1)
  }

  override func tearDown() {
  }

  func test() {
    XCTAssertEqual(12.00, rateUtil.convert(money: Money(amount: 12, currency: "EUR"))!.amount)
    XCTAssertEqual(7.32, rateUtil.convert(money: Money(amount: 10, currency: "CAD"))!.amount)
    XCTAssertNil(rateUtil.convert(money: Money(amount: 10, currency: "NOPE")))

    XCTAssertEqual(9.95, rateUtil.convert(money: Money(amount: 10.0, currency: "CAD"), to: "USD")!.amount)
  }
}
