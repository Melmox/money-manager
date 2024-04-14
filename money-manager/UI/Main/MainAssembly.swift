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

        let viewModelFactory: MainViewModelFactory = MainViewModelFactory()
        let router: MainRouter = MainRouter()
        let exchangeRateService: IExchangeRateService = ExchangeRateService()
        let presenter: MainPresenter = MainPresenter(
            viewModelFactory: viewModelFactory,
            router: router,
            exchangeRateService: exchangeRateService
        )
        let view: MainViewController = MainViewController(presenter: presenter)
        presenter.view = view

        return UINavigationController(rootViewController: view)
    }
}
