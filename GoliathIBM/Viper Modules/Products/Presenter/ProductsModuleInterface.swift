//
//  ProductsModuleInterface.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 26/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

protocol ProductsModuleInterface {
  func setupTableView()
  func setupUI()
  func fetchData()
  func selectProduct(_ name: String)
}
