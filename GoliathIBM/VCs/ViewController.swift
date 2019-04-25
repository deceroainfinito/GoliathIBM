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

  weak var coordinator: MainCoordinator?

  let nProvider = MoyaProvider<GoliathAPI>()

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

    nProvider.request(.rates) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let ratesResponse):
        DispatchQueue.global(qos: .utility).async {
          do {
            let parsedRates = try ratesResponse.map([Rate].self)
            try StorageManager.storeRates(parsedRates)
          } catch {
            print(error.localizedDescription)
          }
        }
      }
    }

    nProvider.request(.transactions) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let tranResponse):
        do {
          let transactions = try tranResponse.map([Transaction].self)
          DispatchQueue.global(qos: .utility).async {
            try! StorageManager.storeTransactions(transactions)
          }
          DispatchQueue.main.async {
            self.transactionViewModels = transactions.unique().map({ TransactionViewModel(transaction: $0) })
            self.tableView.reloadData()
          }
        } catch {
          print(error.localizedDescription)
        }
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
    coordinator?.productTransactions(transactionViewModels[indexPath.row].name)
  }
}
