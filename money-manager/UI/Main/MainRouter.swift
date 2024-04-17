//
//  MainRouter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IMainRouter {
    func showAddTransactionScreen(mainDelegate: MainDelegate)
}

final class MainRouter: IMainRouter {
    
    // MARK: - Properties
    
    weak var transitionHandler: UIViewController?
    private let addTransactionAssembly: IAddTransactionAssembly
    private let transactionService: ITransactionService
    
    // MARK: - Initialization
    
    init(transitionHandler: UIViewController? = nil,
         addTransactionAssembly: IAddTransactionAssembly,
         transactionService: ITransactionService) {
        self.transitionHandler = transitionHandler
        self.addTransactionAssembly = addTransactionAssembly
        self.transactionService = transactionService
    }
    
    // MARK: - IMainRouter
    
    func showAddTransactionScreen(mainDelegate: MainDelegate) {
        let view: UIViewController = addTransactionAssembly.assemble(mainDelegate: mainDelegate, transactionService: transactionService)
        transitionHandler?.navigationController?.pushViewController(view, animated: true)
    }
}
