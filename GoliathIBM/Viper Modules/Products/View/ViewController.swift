//
//  ViewController.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import UIKit
import Moya

class ViewController: UITableViewController {

  var eventHandler: ProductsModuleInterface?

  var transactionViewModels = [TransactionViewModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    eventHandler?.setupTableView()
    eventHandler?.setupUI()
    eventHandler?.fetchData()
  }

  func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
  }
  
  func setupUI() {
    navigationItem.title = "Goliath's Products"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barTintColor = UIColor(named: "goliathBlue")
    navigationController?.navigationBar.largeTitleTextAttributes = [
      .foregroundColor: UIColor.white
    ]
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.white,
    ]
  }
}

extension ViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
    
    cell.textLabel?.text = transactionViewModels[indexPath.row].name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactionViewModels.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    eventHandler?.selectProduct(transactionViewModels[indexPath.row].name)
  }
}


extension ViewController: ProductsViewInterface {
  func showProducts(_ products: [TransactionViewModel]) {
    self.transactionViewModels = products
    self.tableView.reloadData()
  }
}
