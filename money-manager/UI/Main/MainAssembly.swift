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

        let firstOpenStorage: IFirstOpenStorage = FirstOpenStorage()
        if firstOpenStorage.isFirstOpen() ?? true {
            addMockData(transactionService: transactionService)
            firstOpenStorage.save(false)
        }
        
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
    
    private func addMockData(transactionService: ITransactionService) {
        for _ in 0..<35 {
            let transaction: Transaction = Transaction.init(amount: Double.random(in: -100...100), category: TransactionCategory.allCases.randomElement() ?? .other, date: Date(timeIntervalSince1970: TimeInterval.random(in: 1713163070...1713335870)))
            transactionService.saveTransaction(transaction: transaction) { _ in }
        }
    }
}
