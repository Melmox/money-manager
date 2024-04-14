//
//  ExchangeRate.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

struct ExchangeRate: Codable {
    let code: String
    let symbol: String
    let description: String
    let rate: String
}

struct BitcoinData: Codable {
    let bpi: [String: ExchangeRate]
}
