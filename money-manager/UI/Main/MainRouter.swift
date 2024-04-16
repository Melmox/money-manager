//
//  MainRouter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IMainRouter {
    func showAddTransactionScreen()
}

final class MainRouter: IMainRouter {
    
    // MARK: - Properties
    
    weak var transitionHandler: UIViewController?
    private let addTransactionAssembly: IAddTransactionAssembly
    
    // MARK: - Initialization
    
    init(transitionHandler: UIViewController? = nil,
         addTransactionAssembly: IAddTransactionAssembly) {
        self.transitionHandler = transitionHandler
        self.addTransactionAssembly = addTransactionAssembly
    }
    
    // MARK: - IMainRouter
    
    func showAddTransactionScreen() {
        let view: UIViewController = addTransactionAssembly.assemble()
        transitionHandler?.navigationController?.pushViewController(view, animated: true)
    }
}
