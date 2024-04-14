//
//  ExchangeRateStorage.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IExchangeRateStorage {
    func getExchangeRate() -> BitcoinData?
    func saveExchangeRate(_ exchnageRate: BitcoinData)
    func clear()
}

final class ExchangeRateStorage: IExchangeRateStorage {

    // MARK: - Properties
    
    private let storage: Storable
    private let kExchangeRateKey: String = "kExchangeRateKey"

    // MARK: - Initialization
    
    init(storage: Storable = Storage()) {
        self.storage = storage
    }

    // MARK: - IExchangeRateStorage

    func getExchangeRate() -> BitcoinData? {
        return storage.value(forKey: kExchangeRateKey)
    }

    func saveExchangeRate(_ exchnageRate: BitcoinData) {
        storage.set(exchnageRate, forKey: kExchangeRateKey)
    }

    func clear() {
        storage.clearValue(forKey: kExchangeRateKey)
    }
}
