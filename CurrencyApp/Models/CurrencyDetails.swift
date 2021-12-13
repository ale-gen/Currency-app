//
//  CurrencyDetails.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 13/12/2021.
//

import Foundation

struct CurrencyDetails: Codable {
    let table: String
    let currency: String
    let code: String
    let rates: [RateDetails]
}

struct RateDetails: Codable {
    let effectiveDate: String
    let mid: Double
}
