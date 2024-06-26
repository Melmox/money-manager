//
//  NetworkError.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case network(NSError)
    case parser
    case server(ServerError)
    case unknown
    case invalidURL
    
    // MARK: - LocalizedError
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .parser:
            return "Sometring wrong with model"
        case .unknown:
            return "Wrong request"
        case .server(let error):
            return error.errorDescription
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

struct ServerError: LocalizedError {
    let errorDescription: String?
}
