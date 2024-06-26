//
//  ExchangeRate.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

struct ExchangeRate: Codable {
    let rate: String
}

struct BitcoinData: Codable {
    let bpi: [String: ExchangeRate]
    var creationTime: Double?
}
