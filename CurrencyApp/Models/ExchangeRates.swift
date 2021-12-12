//
//  ExchangeRates.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 10/12/2021.
//

import Foundation

struct ExchangeRates: Codable {
    let table: String
    let effectiveDate: String
    let rates: [Rates]
}

struct Rates: Codable {
    let currency: String
    let code: String
    let mid: Double
}
