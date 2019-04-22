//
//  ExtensionsTests.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
@testable import GoliathIBM

class ExtensionsTests: XCTestCase {

  var rates1: [Rate]!
  var rateUtil: RatesUtil!

  override func setUp() {
    rates1 = [
      Rate(from: "EUR", to: "USD", rate: "1.359"),
      Rate(from: "CAD", to: "EUR", rate: "0.732"),
      Rate(from: "USD", to: "EUR", rate: "0.736"),
      Rate(from: "EUR", to: "CAD", rate: "1.366")
    ]

    rateUtil = RatesUtil(rates: rates1)  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testTransactionArrayExtension() {
    var transactions = [
      Transaction(sku: "sku1", amount: "10.00", currency: "EUR"),
      Transaction(sku: "sku2", amount: "10.00", currency: "USD"),
      Transaction(sku: "sku3", amount: "10.00", currency: "CAD"),
      Transaction(sku: "sku1", amount: "10.00", currency: "NOPE")
    ]

    XCTAssertEqual(3, transactions.unique().count)

    transactions.uniqued()
    XCTAssertEqual(3, transactions.count)
  }

  func testMoneyArrayExtension() {
    let lotsOfEUR = [
      Money(amount: 10.0, currency: "EUR"),
      Money(amount: 20.0, currency: "EUR")
    ]

    let lotsOfMoney = lotsOfEUR + [Money(amount: 10.00, currency: "USD")]

    let funnyMoney = lotsOfMoney + [Money(amount: 10.00, currency: "NOPE")]

    XCTAssertEqual(Money(amount: 30.0, currency: "EUR"), lotsOfEUR.sumWithRateUtil(rateUtil))
    XCTAssertEqual(Money(amount: 37.36, currency: "EUR"), lotsOfMoney.sumWithRateUtil(rateUtil))
    XCTAssertNil(funnyMoney.sumWithRateUtil(rateUtil))
  }

  func testStringArrayUniqueness() {
    XCTAssertEqual(["a", "b"], ["a", "a", "b"].unique())
    XCTAssertEqual(["a", "b", "c"], ["a", "a", "b", "c", "a"].unique())
    XCTAssertEqual([], [String]().unique())

    var aS = ["a", "a"]
    aS.uniqued()
    XCTAssertEqual(aS, ["a"])
  }

  func testDoubleBankRound() {
    XCTAssertEqual(12, 12.5.bankRound())
    XCTAssertEqual(12, 11.5.bankRound())
    XCTAssertEqual(12, 12.4.bankRound())
    XCTAssertEqual(13, 12.7.bankRound())
  }
}
