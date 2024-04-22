//
//  ErrorShowable.swift
//  money-manager
//
//  Created by developer on 22.04.2024.
//

import UIKit

enum TransactionError: LocalizedError {
    case emptyAmount
    case emptyCategory
    case negativeBalance
    
    var errorDescription: String? {
        switch self {
        case .emptyAmount:
            return "Please, enter amount of transaction."
        case .emptyCategory:
            return "Please, choose category of transaction."
        case .negativeBalance:
            return "Your balance will be negative after this transaction.\nPlease top up your balance or try creating a transaction with a smaller amount."
        }
    }
}
    
protocol ErrorShowable {
    func showError(_ error: TransactionError)
}

extension ErrorShowable where Self: UIViewController {
    
    func showError(_ error: TransactionError) {
        let alertController: UIAlertController = UIAlertController(title: "Error occured", message: error.errorDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true)
    }
}
