//
//  MainCoordinator.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 26/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  func start()
}

class MainCoordinator: Coordinator {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let vc = ViewController()

    vc.coordinator = self

    navigationController.pushViewController(vc, animated: true)
  }

  func productTransactions(_ name: String) {
    let vc = ProductTableViewController()

    vc.productName = name
    navigationController.pushViewController(vc, animated: true)
  }

}
