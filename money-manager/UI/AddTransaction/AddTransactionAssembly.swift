//
//  AddTransactionAssembly.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IAddTransactionAssembly {
    func assemble(mainDelegate: MainDelegate, transactionService: ITransactionService) -> UIViewController
}

final class AddTransactionAssembly: IAddTransactionAssembly {
    
    func assemble(mainDelegate: MainDelegate, transactionService: ITransactionService) -> UIViewController {

        let viewModelFactory: IAddTransactionViewModelFactory = AddTransactionViewModelFactory()
        let router: AddTransactionRouter = AddTransactionRouter()
        let presenter: AddTransactionPresenter = AddTransactionPresenter(
            viewModelFactory: viewModelFactory,
            transactionService: transactionService,
            router: router,
            mainDelegate: mainDelegate
        )
        let view: IAddTransactionViewController = AddTransactionViewController(presenter: presenter)
        presenter.view = view
        router.transitionHandler = view

        return view
    }
}
