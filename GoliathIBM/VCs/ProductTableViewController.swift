//
//  ProductTableViewController.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {

  var transactions = [TransactionViewModel]()
  var productName: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupUI()
    fetchData()
  }

  func setupUI() {
    view.backgroundColor = .white
    navigationItem.title = productName
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barTintColor = UIColor(named: "goliathBlue")
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.white,
    ]
    navigationController?.navigationBar.largeTitleTextAttributes = [
      .foregroundColor: UIColor.white,
      .font: UIFont.boldSystemFont(ofSize: 30),
    ]
  }

  func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionDetailCell")
  }

  func fetchData() {
    let allTransactions = try! StorageManager.loadTransactions()
    let productTransactions = allTransactions.filter({ (tran) -> Bool in
      tran.sku == self.productName
    }).map({ TransactionViewModel(transaction: $0)})
    let sum = productTransactions.map({ $0.transaction.money }).sumWithRateUtil(RatesUtil.shared)

    DispatchQueue.main.async {
      if let sum = sum {
        self.navigationItem.title = self.navigationItem.title! + " : " + sum.rounded.description
      } else {
        self.navigationItem.title = self.navigationItem.title! + " : Error"
      }

      self.transactions = productTransactions
      self.tableView.reloadData()
    }

  }
}

extension ProductTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell", for: indexPath)

    cell.textLabel?.text = transactions[indexPath.row].conversion

    return cell
  }
}
