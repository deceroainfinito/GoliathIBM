//
//  MockRates.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
@testable import GoliathIBM

let ratesURL = Bundle.init(for: JSONTestCase.self).url(forResource: "rates", withExtension: "json")

class MockRates: XCTestCase {

  var endPoint: RateEndPoint!
  var router: Router<RateEndPoint>!
  var service: RatesService!

  var data: Data!
  var error: Error!

  override func setUp() {

    data = try! Data.init(contentsOf: ratesURL!)

    endPoint = RateEndPoint.allRates
    router = Router<RateEndPoint>(session: URLSessionMock(data: data, error: nil))
    service = RatesService(router: router)
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testAllRatesEndPoint() {
    XCTAssertEqual(endPoint.baseURL.absoluteString, "http://quiet-stone-2094.herokuapp.com")
    // ...
  }

  func testRouter() {
    let expectation = XCTestExpectation(description: "Big Expectations!")
    service.fetchRates { (result) in
      XCTAssertNotNil(result)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 5)
  }

}
