//
//  MainAssembly.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IMainAssembly {
    func assemble() -> UIViewController
}

final class MainAssembly: IMainAssembly {
    
    func assemble() -> UIViewController {
        let addTransactionAssembly: IAddTransactionAssembly = AddTransactionAssembly()
        let transactionService: ITransactionService = TransactionService()

        let viewModelFactory: MainViewModelFactory = MainViewModelFactory()
        let router: MainRouter = MainRouter(addTransactionAssembly: addTransactionAssembly, transactionService: transactionService)
        let exchangeRateService: IExchangeRateService = ExchangeRateService()
        let presenter: MainPresenter = MainPresenter(
            viewModelFactory: viewModelFactory,
            router: router,
            exchangeRateService: exchangeRateService,
            transactionService: transactionService
        )
        let view: MainViewController = MainViewController(presenter: presenter)
        presenter.view = view
        router.transitionHandler = view

        return UINavigationController(rootViewController: view)
    }
}
