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
        networkService.request(request: request, parser: parser, completion: completion)
    }
}
