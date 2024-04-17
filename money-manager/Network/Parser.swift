//
//  Parser.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol Parser {
    func parse<T: Decodable>(result: Any) -> Result<T, NetworkError>
}

final class BaseParser: Parser {

    func parse<T: Decodable>(result: Any) -> Result<T, NetworkError> {
        if let data: Data = result as? Data {
            let jsonDecoder: JSONDecoder = JSONDecoder.common

            do {
                guard let object: T = try? jsonDecoder.decode(
                    T.self, from: data
                ) else {
                    if let object: T = String(data: data, encoding: .utf8) as? T {
                        return .success(object)
                    } else {
                        print("failed parse: \(String(data: data, encoding: .utf8) ?? "unknown")")
                        return .failure(.parser)
                    }
                }

                return .success(object)
            }
        } else {
            return .failure(.parser)
        }
    }
}
