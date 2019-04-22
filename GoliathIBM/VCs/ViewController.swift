//
//  ViewController.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var transactionViewModels = [TransactionViewModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupUI()
    fetchData()
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
  
  func fetchData() {
    RatesService.shared.fetchRates { (result) in
      switch result {
      case .success(let rates):
        DispatchQueue.global(qos: .utility).async {
          try! StorageManager.storeRates(rates)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
    TransactionService.shared.fetchTransactions { (result) in
      switch result {
      case .success(let transactions):
        DispatchQueue.global(qos: .utility).async {
          try! StorageManager.storeTransactions(transactions)
        }
        DispatchQueue.main.async {
          self.transactionViewModels = transactions.unique().map({ TransactionViewModel(transaction: $0) })
          self.tableView.reloadData()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
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
    let vc = ProductTableViewController()
    vc.productName = transactionViewModels[indexPath.row].name
    
    navigationController?.pushViewController(vc, animated: true)
  }
}
