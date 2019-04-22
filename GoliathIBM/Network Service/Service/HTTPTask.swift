//
//  HTTPTask.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
  case request

  case requestParameters(bodyParameters: Parameters?,
    bodyEncoding: ParameterEncoding,
    urlParameters: Parameters?)

  case requestParametersAndHeaders(bodyParameters: Parameters?,
    bodyEnconding: ParameterEncoding,
    urlParameters: Parameters?,
    additionHeaders: HTTPHeaders?)
}
