//
//  JSONTestCase.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
@testable import GoliathIBM

class JSONTestCase: XCTestCase {

  let ratesURL = Bundle.init(for: JSONTestCase.self).url(forResource: "rates", withExtension: "json")
  let transactionsURL = Bundle.init(for: JSONTestCase.self).url(forResource: "transactions", withExtension: "json")

  var rates: [Rate]?
  var transactions: [Transaction]?

  override func setUp() {
    var data = try! Data.init(contentsOf: ratesURL!)
    rates = try! JSONDecoder().decode([Rate].self, from: data)
    data = try! Data.init(contentsOf: transactionsURL!)
    transactions = try! JSONDecoder().decode([Transaction].self, from: data)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testRatesAndTransactionsParsing() {
    XCTAssertEqual(rates?.count, 6)
    XCTAssertEqual(rates?.first, Rate(from: "EUR", to: "CAD", rate: "0.98"))
    XCTAssertEqual(transactions?.count, 5205)
    XCTAssertEqual(transactions?.first, Transaction(sku: "N6588", amount: "26.8", currency: "CAD"))
  }
}
