//
//  UDStorage.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

class Storage: Storable {

    // Dependencies
    private let userDefaults: UserDefaults = .standard

    // MARK: - Storable

    func value<Value: Codable>(forKey key: String) -> Value? {
        if let data: Data  = userDefaults.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(Value.self, from: data)
        } else {
            return nil
        }
    }

    func set<Value: Codable>(_ value: Value, forKey key: String) {
        if let data: Data = try? JSONEncoder().encode(value) {
            userDefaults.set(data, forKey: key)
        }
    }

    func clearValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
