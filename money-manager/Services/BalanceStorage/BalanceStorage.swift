//
//  BalanceStorage.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IBalanceStorage {
    func getBalance() -> Double?
    func saveBalance(_ balance: Double?)
    func clear()
}

final class BalanceStorage: IBalanceStorage {

    // MARK: - Properties
    
    private let storage: Storable
    private let kBalanceKey: String = "kBalanceKey"

    // MARK: - Initialization
    
    init(storage: Storable = Storage()) {
        self.storage = storage
    }

    // MARK: - IBalanceStorage

    func getBalance() -> Double? {
        return storage.value(forKey: kBalanceKey) ?? .zero
    }

    func saveBalance(_ balance: Double?) {
        storage.set(balance, forKey: kBalanceKey)
    }

    func clear() {
        storage.clearValue(forKey: kBalanceKey)
    }
}
