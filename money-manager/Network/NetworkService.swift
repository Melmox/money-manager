//
//  NetworkService.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol INetworkService {
    func request<T: Decodable>(request: IRequest, parser: Parser, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkService: INetworkService {
    
    // MARK: - INetworkService
    
    func request<T: Decodable>(request: IRequest, parser: Parser, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: request.path) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            
            if let error = error as? NSError {
                let networkError: NetworkError = self.handleError(from: error, data: data, statusCode: (response as? HTTPURLResponse)?.statusCode)
                completion(.failure(networkError))
                return
            }
            
            if let data: Data = data {
                let parsingResult: Result<T, NetworkError> = parser.parse(result: data)
                completion(parsingResult)
                return
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Functions

    private func handleError(from error: NSError, data: Data?, statusCode: Int?) -> NetworkError {
        if let data: Data = data,
           let errorDescription: String = String(data: data, encoding: String.Encoding.utf8) {
            return .server(.init(errorDescription: errorDescription))
        } else {
            return .network(error)
        }
    }
}
