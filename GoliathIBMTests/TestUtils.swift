//
//  TestUtils.swift
//  GoliathIBMTests
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
  private let closure: () -> Void

  init(closure: @escaping () -> Void) {
    self.closure = closure
  }

  override func resume() {
    closure()
  }
}


class URLSessionMock: URLSession {
  var data: Data?
  var error: Error?
  var response: URLResponse?

  init(data: Data?, error: Error?) {
    self.data = data
    self.error = error

    let resp = HTTPURLResponse(url: URL(string: "https://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

    self.response = resp
  }

  override func dataTask(with request: URLRequest,
                         completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

    return URLSessionDataTaskMock {
      completionHandler(self.data, self.response, self.error)
    }
  }
}
