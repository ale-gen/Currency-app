//
//  CurrencyRatesViewModel.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 10/12/2021.
//

import Foundation
import UIKit

enum Result: Error {
    case success
    case failure
}

class CurrencyRatesViewModel: NSObject {
    
    @IBOutlet var apiService: ApiService!
    var exchangeRates: [Rates]?
    var isLoading = false
    var isShowingError = false
    var errorMessage: String? {
        didSet {
            isShowingError = errorMessage != nil
        }
    }
    
    override init() {
        super.init()
        self.apiService = ApiService()
    }
    
    func fetchCurrencies(completionForSpinner: @escaping (Bool) -> (Void), completion: @escaping (Result) -> Void) {
        apiService.sendRequest(endpoint: "A") { data in
            if let safeData = data {
                do {
                    self.isLoading = true
                    completionForSpinner(self.isLoading)
                    let exchangeRates = try JSONDecoder().decode([ExchangeRates].self, from: safeData)
                    self.exchangeRates = exchangeRates[0].rates
                    completion(.success)
                } catch {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    completionForSpinner(self.isLoading)
                    completion(.failure)
                }
            }
            self.isLoading = false
            completionForSpinner(self.isLoading)
        }
    }
}
