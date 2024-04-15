//
//  AddTransactionAssembly.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IAddTransactionAssembly {
    func assemble() -> UIViewController
}

final class AddTransactionAssembly: IAddTransactionAssembly {
    
    func assemble() -> UIViewController {

        let viewModelFactory: IAddTransactionViewModelFactory = AddTransactionViewModelFactory()
        let router: AddTransactionRouter = AddTransactionRouter()
        let presenter: AddTransactionPresenter = AddTransactionPresenter(
            viewModelFactory: viewModelFactory,
            router: router
        )
        let view: IAddTransactionViewController = AddTransactionViewController(presenter: presenter)
        presenter.view = view
        router.transitionHandler = view

        return view
    }
}
