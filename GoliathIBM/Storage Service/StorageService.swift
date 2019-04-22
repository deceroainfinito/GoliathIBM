//
//  StorageService.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

enum StorageManagerError: Error {
  case noCacheDirectory
  case cantStore
  case fileDontExist
  case cantLoadModel
  case noData
  case cantClean
}

class StorageManager {
  static var shared = StorageManager()

  fileprivate enum StorageType: String {
    case rates
    case transactions
  }

  static private let ratesFileName = "rates"
  static private let transactionsFileName = "transactions"

  static private let cacheDirectory: URL? = {
    var tmpDirectory = FileManager.SearchPathDirectory.cachesDirectory

    return FileManager.default.urls(for: tmpDirectory, in: .userDomainMask).first
  }()

  static func storeRates(_ rates: [Rate]) throws {
    try store(rates, type: StorageType.rates)
  }

  static func storeTransactions(_ transactions: [Transaction]) throws {
    try store(transactions, type: StorageType.transactions)
  }

  static fileprivate func store<T: Encodable>(_ object: T, type: StorageType) throws {
    guard let url = cacheDirectory?.appendingPathComponent(type.rawValue, isDirectory: false) else {
      throw StorageManagerError.noCacheDirectory
    }

    let encoder = JSONEncoder()

    do {
      let data = try encoder.encode(object)
      if FileManager.default.fileExists(atPath: url.path) {
        try FileManager.default.removeItem(at: url)
      }
      FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    } catch {
      print(error.localizedDescription)
      throw StorageManagerError.cantStore
    }
  }

  static func loadRates() throws -> [Rate] {
    return try load([Rate].self, of: .rates)
  }

  static func loadTransactions() throws -> [Transaction] {
    return try load([Transaction].self, of: .transactions)
  }

  static fileprivate func load<T: Decodable>(_ model: T.Type, of type: StorageType) throws -> T  {
    guard let url = cacheDirectory?.appendingPathComponent(type.rawValue, isDirectory: false) else {
      throw StorageManagerError.noCacheDirectory
    }

    if !FileManager.default.fileExists(atPath: url.path) {
      print("File at path \(url.path) does not exist")
      throw StorageManagerError.fileDontExist
    }

    if let data = FileManager.default.contents(atPath: url.path) {
      let decoder = JSONDecoder()

      do {
        let loadedData = try decoder.decode(model, from: data)
        return loadedData
      } catch {
        print("Can't load \(model)")
        throw StorageManagerError.cantLoadModel
      }
    } else {
      print("No data at \(url.path)!")
      throw StorageManagerError.noData
    }
  }

  static func clearRolesAndTransactions() throws {
    guard let url = cacheDirectory else { throw StorageManagerError.noCacheDirectory }
    do {
      let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
      for fileUrl in contents {
        try FileManager.default.removeItem(at: fileUrl)
      }
    } catch {
      print(error.localizedDescription)
      throw StorageManagerError.cantClean
    }
  }
}
