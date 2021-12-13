//
//  CurrencyDetailViewController.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 13/12/2021.
//

import Foundation
import UIKit

class CurrencyDetailViewController: UIViewController {
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    var rates: Rates?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var currencyViewModel: CurrencyRatesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureLabels()
        configureSpinner()
        configureDatePickers()
        refresh()
        tableView.dataSource = self
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    func refresh() {
        currencyViewModel.fetchCurrencyDetails { isLoading in
            DispatchQueue.main.async {
                self.manageSpinnerShowing(isLoading: isLoading)
            }
        } completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableView.reloadData()
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
    
    func configureSpinner() {
        spinnerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinnerView.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        spinnerView.layer.cornerRadius = 10
    }
    
    func manageSpinnerShowing(isLoading: Bool) {
        if (isLoading) {
            self.spinnerView.startAnimating()
        } else {
            self.spinnerView.stopAnimating()
        }
    }
    
    func configureNavigationBar() {
        navigationItem.backBarButtonItem?.title = "Back"
        if let safeRate = rates {
            self.title = safeRate.currency.capitalized
        }
    }
    
    func configureLabels() {
        startDateLabel.layer.masksToBounds = true
        startDateLabel.layer.cornerRadius = 15
        
        endDateLabel.layer.masksToBounds = true
        endDateLabel.layer.cornerRadius = 15
    }
    
    func configureDatePickers() {
//        startDatePicker
    }
}

extension CurrencyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyViewModel.currencyDetails?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.currencyDetailsCellIdentifier, for: indexPath) as! UITableViewCell
        configureCell(cell, for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        if let safeRate = currencyViewModel.currencyDetails?.rates[indexPath.row] {
            cell.textLabel?.text = String(safeRate.mid)
        }
    }
}
