//
//  FirstOpenStorage.swift
//  money-manager
//
//  Created by developer on 17.04.2024.
//

import Foundation

protocol IFirstOpenStorage {
    func isFirstOpen() -> Bool?
    func save(_ isFirstOpen: Bool?)
    func clear()
}

final class FirstOpenStorage: IFirstOpenStorage {

    // MARK: - Properties
    
    private let storage: Storable
    private let kFirstOpenKey: String = "kFirstOpenKey"

    // MARK: - Initialization
    
    init(storage: Storable = Storage()) {
        self.storage = storage
    }

    // MARK: - IFirstOpenStorage

    func isFirstOpen() -> Bool? {
        return storage.value(forKey: kFirstOpenKey)
    }

    func save(_ isFirstOpen: Bool?) {
        storage.set(isFirstOpen, forKey: kFirstOpenKey)
    }

    func clear() {
        storage.clearValue(forKey: kFirstOpenKey)
    }
}
