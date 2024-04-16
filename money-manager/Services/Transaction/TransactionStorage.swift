//
//  TransactionStorage.swift
//  money-manager
//
//  Created by developer on 15.04.2024.
//

import CoreData

protocol ITransactionStorage {
    func save(transaction: Transaction)
    func getAllTransactions() -> [Transaction]
    func getTransactionsWith(offset: Int, limit: Int) -> [Transaction]
    func clearTransactions()
}

final class TransactionStorage: ITransactionStorage {
    
    // MARK: - Properties
    
    private let dbStorage: IDBStorage
    
    // MARK: - Initialization
    
    init(dbStorage: IDBStorage = DBStorage.shared) {
        self.dbStorage = dbStorage
    }
    
    // MARK: - ITransactionStorage
    
    func save(transaction: Transaction) {
        dbStorage.saveAndWait(block: { context in
            DBTransaction.from(transaction: transaction, in: context)
        }, completion: nil)
    }

    func getAllTransactions() -> [Transaction] {
        var transactions: [Transaction] = []
        
        dbStorage.defaultContextAndWait { context in
            transactions = DBTransaction.allObjects(in: context).map { $0.toTransaction() }
        }
                
        return transactions
    }
    
    func getTransactionsWith(offset: Int, limit: Int) -> [Transaction] {
        var transactions: [Transaction] = []
        
        dbStorage.defaultContextAndWait { context in
            transactions = DBTransaction.objectsWith(offset: offset, limit: limit, in: context).map { $0.toTransaction() }
        }
        
        return transactions
    }
    
    func clearTransactions() {
        dbStorage.removeAllEntitiesWithName(DBTransaction._entityName, completion: nil)
    }
}

private extension DBTransaction {

    @discardableResult
    static func from(transaction: Transaction, in context: NSManagedObjectContext) -> DBTransaction? {
        let dbTransaction: DBTransaction? = DBTransaction.makeObject(in: context)
        dbTransaction?.amount = transaction.amount
        dbTransaction?.category = transaction.category.rawValue
        dbTransaction?.date = transaction.date

        return dbTransaction
    }

    func toTransaction() -> Transaction {
        guard let date = date else { return .init(amount: amount, category: getTransactionCategory(), date: Date()) }
        return .init(amount: amount,
                     category: getTransactionCategory(),
                     date: date)
    }
}
