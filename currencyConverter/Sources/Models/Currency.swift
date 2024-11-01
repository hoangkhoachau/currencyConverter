//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Hoang Khoa on 11/1/24.
//

import Foundation

struct Currency: Codable, Identifiable {
    let name: String
    let shortName: String
    let ratesOnUSD: Double?
    var id: String { name }
}
