//
//  DBTransaction.swift
//  money-manager
//
//  Created by developer on 15.04.2024.
//
//

import CoreData

class DBTransaction: NSManagedObject, DBStorableObject {

    public static var primaryKey: String {
        "date"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: "date", ascending: false)]
    }
    
    func getTransactionCategory() -> TransactionCategory {
        guard let category = category else { return .other}
        return TransactionCategory.init(rawValue: category) ?? .other
    }
}
