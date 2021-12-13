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
        configureSubviews()
        refresh()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    func refresh() {
        getDatesFromPickers()
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
        currencyViewModel.resetCurrentData()
        tableView.reloadData()
    }
    
    private func manageSpinnerShowing(isLoading: Bool) {
        if (isLoading) {
            self.spinnerView.startAnimating()
        } else {
            self.spinnerView.stopAnimating()
        }
    }

}

//MARK: - Subviews Configuration methods
extension CurrencyDetailViewController {
    
    func configureSubviews() {
        configureNavigationBar()
        configureLabels()
        configureSpinner()
        configureDatePickers()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.currencyDetailsNibName, bundle: nil), forCellReuseIdentifier: K.currencyDetailsCellIdentifier)
    }
    
    private func configureSpinner() {
        spinnerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinnerView.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        spinnerView.layer.cornerRadius = 10
    }
    
    private func configureNavigationBar() {
        navigationItem.backBarButtonItem?.title = "Back"
        if let safeRate = rates {
            self.title = safeRate.currency.capitalized
        }
    }
    
    private func configureLabels() {
        startDateLabel.layer.masksToBounds = true
        startDateLabel.layer.cornerRadius = 15
        
        endDateLabel.layer.masksToBounds = true
        endDateLabel.layer.cornerRadius = 15
    }
    
    private func configureDatePickers() {
        startDatePicker.semanticContentAttribute = .forceRightToLeft
        startDatePicker.center = CGPoint(x: self.startDateLabel.frame.midX, y: startDatePicker.frame.midY)
        
        endDatePicker.semanticContentAttribute = .forceRightToLeft
        endDatePicker.center = CGPoint(x: self.endDateLabel.frame.midX, y: startDatePicker.frame.midY)
        
        startDatePicker.backgroundColor = .white
        startDatePicker.layer.cornerRadius = 5
        
        endDatePicker.backgroundColor = .white
        endDatePicker.layer.cornerRadius = 5
        startDatePicker.subviews.forEach({ $0.subviews.forEach({ $0.removeFromSuperview() }) })
        
        setDefaultDates()
    }
}

extension CurrencyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyViewModel.currencyDetails?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.currencyDetailsCellIdentifier, for: indexPath) as! CurrencyDetailsCell
        configureCell(cell, for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: CurrencyDetailsCell, for indexPath: IndexPath) {
        if let safeRate = currencyViewModel.currencyDetails?.rates[indexPath.row] {
            cell.dateLabel.text = safeRate.effectiveDate
            cell.midLabel.text = String(safeRate.mid)
        }
    }
}

//MARK: - functionality of date pickers
extension CurrencyDetailViewController {
    
    private func getDatesFromPickers() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let startDatePickerValue = dateFormatter.string(from: startDatePicker.date)
        let endDatePickerValue = dateFormatter.string(from: endDatePicker.date)
        currencyViewModel.startDate = startDatePickerValue
        currencyViewModel.endDate = endDatePickerValue
    }
    
    private func setDefaultDates() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: date)
        let startDateString = "\(year)-\(month)-01"
        let endDateString = "\(year)-\(month)-\(day)"
        dateFormatter.dateFormat = "YYYY-MM-dd"
        startDatePicker.setDate(dateFormatter.date(from: startDateString)!, animated: false)
        endDatePicker.setDate(dateFormatter.date(from: endDateString)!, animated: false)
    }
}
