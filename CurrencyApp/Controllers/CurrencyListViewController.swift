//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 10/12/2021.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet var currencyViewModel: CurrencyRatesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpinner()
        configureSegmentedControl()
        currencyTableView.register(UINib(nibName: K.currecnyCellNibName, bundle: nil), forCellReuseIdentifier: K.currencyCellIdentifier)
        refresh()
        currencyTableView.delegate = self
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    @IBAction func onSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currencyViewModel.endpoint = "A"
        } else if sender.selectedSegmentIndex == 1 {
            currencyViewModel.endpoint = "B"
        } else {
            currencyViewModel.endpoint = "C"
        }
        refresh()
    }
    
    
    func refresh() {
        currencyViewModel.fetchCurrencies { isLoading in
            DispatchQueue.main.async {
                self.manageSpinnerShowing(isLoading: isLoading)
            }
        } completion: { result in
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
    
    func configureSegmentedControl() {
        let titleTextAttributeForSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributeForNormal = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributeForNormal, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributeForSelected, for: .selected)
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
}

extension CurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyViewModel.exchangeRates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.currencyCellIdentifier, for: indexPath) as! CurrencyCell
        configureCell(cell, for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: CurrencyCell, for indexPath: IndexPath) {
        if let safeRate = currencyViewModel.exchangeRates?[indexPath.row] {
            cell.codeLabel.text = safeRate.code
            cell.currencyLabel.text = safeRate.currency.capitalized
            cell.midLabel.text = String(safeRate.mid)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.performSegue(withIdentifier: K.currencyDatailSegue, sender: self)
    }
    
    
    
}


