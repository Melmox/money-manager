//
//  ExchangeRateService.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IExchangeRateService {
    func getExchangeRate(completion: @escaping (Result<BitcoinData, NetworkError>) -> Void)
}

final class ExchangeRateService: IExchangeRateService {
    
    // MARK: - Properties
    
    private let networkService: INetworkService
    private let parser: Parser
    private let exchangeRateStorage: IExchangeRateStorage = ExchangeRateStorage()
    
    // MARK: - Initialization
    
    init(
        networkService: INetworkService = NetworkService(),
        parser: Parser = BaseParser()
    ) {
        self.networkService = networkService
        self.parser = parser
    }
    
    // MARK: - IExchangeRateService
    
    func getExchangeRate(completion: @escaping (Result<BitcoinData, NetworkError>) -> Void) {
        let request: Request = Request(
            path: "https://api.coindesk.com/v1/bpi/currentprice.json",
            method: .get)
        
        if let exchangeRate: BitcoinData = exchangeRateStorage.getExchangeRate(),
           Date().timeIntervalSince1970 < exchangeRate.creationTime + 3600 {
            completion(.success(exchangeRate))
            return
        }
        
        networkService.request(request: request, parser: parser) { [weak self] (result: Result<BitcoinData, NetworkError>) in
            
            switch result {
            case .success(let exnchageRate):
                self?.exchangeRateStorage.saveExchangeRate(exnchageRate)
                completion(.success(exnchageRate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
