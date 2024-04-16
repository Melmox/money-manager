//
//  TransactionService.swift
//  money-manager
//
//  Created by developer on 16.04.2024.
//

import Foundation

protocol ITransactionService {
    func getTransactionsWith(offset: Int, limit: Int, completion: @escaping (Result<[Transaction], NetworkError>) -> Void)
    func getAllTransactions(completion: @escaping (Result<[Transaction], NetworkError>) -> Void)
    func saveTransaction(transaction: Transaction, completion: @escaping (Result<(), NetworkError>) -> Void)
    func clearTransactions(completion: @escaping (Result<(), NetworkError>) -> Void)
}

final class TransactionService: ITransactionService {
    
    // MARK: - Properties
    
    private let transactionStorage: ITransactionStorage
    
    // MARK: - Initialization
    
    init(transactionStorage: ITransactionStorage = TransactionStorage()) {
        self.transactionStorage = transactionStorage
    }
    
    // MARK: - ITransactionService
    
    func getTransactionsWith(offset: Int, limit: Int, completion: @escaping (Result<[Transaction], NetworkError>) -> Void) {
        let transactions: [Transaction] = transactionStorage.getTransactionsWith(offset: offset, limit: limit)
        completion(.success(transactions))
    }
    
    func getAllTransactions(completion: @escaping (Result<[Transaction], NetworkError>) -> Void) {
        let transactions: [Transaction] = transactionStorage.getAllTransactions()
        completion(.success(transactions))
    }

    func saveTransaction(transaction: Transaction, completion: @escaping (Result<(), NetworkError>) -> Void) {
        transactionStorage.save(transaction: transaction)
        completion(.success(()))
    }

    func clearTransactions(completion: @escaping (Result<(), NetworkError>) -> Void) {
        transactionStorage.clearTransactions()
        completion(.success(()))
    }
}
