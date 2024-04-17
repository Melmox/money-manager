//
//  AddTransactionRouter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IAddTransactionRouter {
    func closeScreen()
}

final class AddTransactionRouter: IAddTransactionRouter {
    
    // MARK: - Properties
    
    weak var transitionHandler: UIViewController?
    
    // MARK: - Initialization

    init(transitionHandler: UIViewController? = nil) {
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - IAddTransactionRouter
    
    func closeScreen() {
        transitionHandler?.navigationController?.popViewController(animated: true)
    }
}
