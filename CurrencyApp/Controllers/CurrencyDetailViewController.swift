//
//  CurrencyDetailViewController.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 13/12/2021.
//

import Foundation
import UIKit

class CurrencyDetailViewController: UIViewController {
    
    var rates: Rates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationItem.backBarButtonItem?.title = "Back"
        if let safeRate = rates {
            self.title = safeRate.currency.capitalized
        }
    }
}
