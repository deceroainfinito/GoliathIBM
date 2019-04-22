//
//  ViewModelTests.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
@testable import GoliathIBM

class ViewModelTests: XCTestCase {

  override func setUp() {
  }

  override func tearDown() {
  }

  func testRatesViewModel() {
  }

  func testTransactionsViewModel()   {
    let t1 = Transaction(sku: "sku1", amount: "10.00", currency: "EUR")
    let t2 = Transaction(sku: "sku2", amount: "10.00", currency: "USD")
    let t3 = Transaction(sku: "sku3", amount: "10.00", currency: "CAD")
    let t4 = Transaction(sku: "sku4", amount: "10.00", currency: "NOPE")

    var tvm = TransactionViewModel(transaction: t1)

    XCTAssertEqual(tvm.name, "Sku1")
    XCTAssertEqual(tvm.conversion, "10 EUR")

    tvm = TransactionViewModel(transaction: t2)
    XCTAssertEqual(tvm.name, "Sku2")
    XCTAssertEqual(tvm.conversion, "10 USD -> 7.36 EUR")

    tvm = TransactionViewModel(transaction: t3)
    XCTAssertEqual(tvm.conversion, "10 CAD -> 7.32 EUR")

    tvm = TransactionViewModel(transaction: t4)
    XCTAssertEqual(tvm.name, "Sku4")
    XCTAssertEqual(tvm.conversion, "10 NOPE -> No conversion")
  }
}
