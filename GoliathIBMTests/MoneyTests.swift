//
//  MoneyTests.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
@testable import GoliathIBM

class MoneyTests: XCTestCase {

  override func setUp() {
  }

  override func tearDown() {
  }

  func testMoney() {
    let money1 = Money(amount: 10.0, currency: "EUR")
    let money2 = Money(amount: 10.0, currency: "USD")

    XCTAssertEqual("10 EUR", money1.description)
    XCTAssertTrue(money1.isEuro)
    XCTAssertFalse(money2.isEuro)
  }

  func testRoundedMoney() {
    let money1 = Money(amount: 12.5, currency: "EUR")
    let money2 = Money(amount: 13.5, currency: "EUR")
    let money3 = Money(amount: 14.5, currency: "EUR")

    XCTAssertEqual("12.5 EUR", money1.rounded.description)
    XCTAssertEqual("12 EUR", money1.rounded(scale: 0).description)
    XCTAssertEqual(money2.rounded(scale: 0), money3.rounded(scale: 0))
  }

  func testOperators() {
    let money1 = Money(amount: 10.0, currency: "EUR")
    let money2 = Money(amount: 10.0, currency: "USD")
    let money3 = Money(amount: 10.0, currency: "EUR")
    let money4 = Money(amount: 3.5, currency: "CAD")
    let decimalEscalar = Decimal(5.0)
    let doubleEscalar = Double(3.0)

    XCTAssertEqual(Money(amount: 20.0, currency: "EUR"), money1 + money3)
    XCTAssertEqual(Money(amount: 0.0, currency: "EUR"), money1 - money3)
    XCTAssertNil(money1 + money2)
    XCTAssertEqual(Money(amount: 50.0, currency: "EUR"), money1 * decimalEscalar)
    XCTAssertEqual(Money(amount: 10.5, currency: "CAD"), money4 * doubleEscalar)
    XCTAssertEqual(Money(amount: 10, currency: "CAD"), (money4 * doubleEscalar).rounded(scale: 0))
  }
}
