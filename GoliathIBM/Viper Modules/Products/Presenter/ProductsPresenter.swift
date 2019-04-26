//
//  ProductsPresenter.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 26/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import Foundation

class ProductsPresenter: NSObject, ProductsInteractorOutputProtocol, ProductsModuleInterface {

  var coordinator: MainCoordinator!
  var productsInteractor: ProductsInteractorInputProtocol!
  var userInterface: ProductsViewInterface!

  func setupTableView() {
    userInterface.setupTableView()
  }

  func setupUI() {
    userInterface.setupUI()
  }

  func fetchData() {
    productsInteractor.fetchRates()
    productsInteractor.fetchTransactions()
  }

  func products(_ products: [TransactionViewModel]) {
    userInterface.showProducts(products)
  }

  func selectProduct(_ name: String) {
    coordinator.productTransactions(name)
  }
}
