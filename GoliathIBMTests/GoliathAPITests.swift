//
//  GoliathAPITests.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 25/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import XCTest
import Moya
@testable import GoliathIBM

class GoliathAPITests: XCTestCase {

  var provider: MoyaProvider<GoliathAPI>!

  override func setUp() {
  }

  func testRates() {
    provider = MoyaProvider<GoliathAPI>(endpointClosure: mocking200Endpoint, stubClosure: MoyaProvider.immediatelyStub)

    let expectation = XCTestExpectation(description: "Good Rate Expectations")

    provider.request(.rates) { (result) in
      switch result {
      case .success(let response):
        XCTAssertTrue(response.statusCode == 200)
        XCTAssertEqual("http://quiet-stone-2094.herokuapp.com/rates", response.request?.url?.absoluteString)
        XCTAssertEqual(try! response.map([Rate].self).count, 6)
        expectation.fulfill()
      case .failure(let error):
        XCTFail(error.errorDescription!)
      }
    }

    wait(for: [expectation], timeout: 5)
  }

  func mocking200Endpoint(_ api: GoliathAPI) -> Endpoint {
    return Endpoint(url: URL(target: api).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, api.testSampleData) },
                    method: api.method,
                    task: api.task,
                    httpHeaderFields: api.headers)
  }
}

extension GoliathAPI {
  var testSampleData: Data {
    let url: URL!

    switch self {
    case .rates:
      url =  Bundle(for: GoliathAPITests.self).url(forResource: "rates", withExtension: "json")
    case .transactions:
      url =  Bundle(for: GoliathAPITests.self).url(forResource: "transactions", withExtension: "json")
    }

    return try! Data(contentsOf: url)
  }
}

