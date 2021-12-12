//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 10/12/2021.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!
    
    @IBOutlet var currencyViewModel: CurrencyRatesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyViewModel.fetchCurrencies { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.currencyTableView.reloadData()
                case .failure:
                    self.showAlert()
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Cannot load data", message: self.currencyViewModel.errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CurrencyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyViewModel.exchangeRates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.currencyCellIdentifier, for: indexPath) as! UITableViewCell
        configureCell(cell, for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        if let safeRate = currencyViewModel.exchangeRates?[indexPath.row] {
            cell.textLabel?.text = safeRate.code
        }
    }
    
    
}


