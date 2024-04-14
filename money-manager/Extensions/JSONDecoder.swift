//
//  JSONDecoder.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

extension JSONDecoder {
    static let common: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()
}
