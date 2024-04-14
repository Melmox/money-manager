//
//  Storable.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol Storable {
    func value<Value: Codable>(forKey key: String) -> Value?
    func set<Value: Codable>(_ value: Value, forKey key: String)
    func clearValue(forKey key: String)
}
