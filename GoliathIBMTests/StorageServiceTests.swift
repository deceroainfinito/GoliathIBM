//
//  StorageServiceTests.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
@testable import GoliathIBM

class StorageServiceTests: XCTestCase {

  var rates: [Rate]!
  var transactions: [Transaction]!

  override func setUp() {
    rates = [
      Rate(from: "EUR", to: "USD", rate: "1.359"),
      Rate(from: "CAD", to: "EUR", rate: "0.732"),
      Rate(from: "USD", to: "EUR", rate: "0.736"),
      Rate(from: "EUR", to: "CAD", rate: "1.366")
    ]

    transactions = [
      Transaction(sku: "sku1", amount: "10.00", currency: "EUR"),
      Transaction(sku: "sku2", amount: "10.00", currency: "USD"),
      Transaction(sku: "sku3", amount: "10.00", currency: "CAD"),
      Transaction(sku: "sku4", amount: "10.00", currency: "NOPE")
    ]
  }

  override func tearDown() {
  }

  func testNoRatesStoredYet() {
    try! StorageManager.clearRolesAndTransactions()
    XCTAssertThrowsError(try StorageManager.loadRates())
    try! StorageManager.storeRates(rates)
  }

  func testRates() {
    let tmpRates: [Rate]
    do {
      try StorageManager.storeRates(rates)
      tmpRates = try StorageManager.loadRates()

      XCTAssertEqual(rates, tmpRates)
    } catch {
      XCTFail()
    }
  }

  func testNoTransactionsStoredYet() {
    try! StorageManager.clearRolesAndTransactions()
    XCTAssertThrowsError(try StorageManager.loadTransactions())
    try! StorageManager.storeTransactions(transactions)
  }

  func testTransactions() {
    do {
      try StorageManager.storeTransactions(transactions)
      let tmpTransactions = try StorageManager.loadTransactions()

      XCTAssertEqual(transactions, tmpTransactions)
    } catch {
      XCTFail()
    }
  }
}
