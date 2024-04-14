//
//  MainPresenter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation
import UIKit

protocol IMainPresenter {
    func viewDidLoad()
}

final class MainPresenter: IMainPresenter {
    
    // MARK: - Properties
    
    weak var view: IMainViewController?
    private let viewModelFactory: IMainViewModelFactory
    private let router: IMainRouter
    private let exchangeRateService: IExchangeRateService
    
    // MARK: - Initialization

    init(viewModelFactory: IMainViewModelFactory, router: IMainRouter, exchangeRateService: IExchangeRateService) {
        self.viewModelFactory = viewModelFactory
        self.router = router
        self.exchangeRateService = exchangeRateService
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Private Functions
    
    private func getExchangeRate() {
        view?.showActivityIndicator()

        exchangeRateService.getExchangeRate { [weak self] result in
            self?.view?.removeActivityIndicator()

            switch result {
            case .success(let exchangeRate):
                self?.view?.setup(with: MainViewModel())
            case .failure:
                break
            }
        }
    }
    
    // MARK: - IMainPresenter
    
    func viewDidLoad() {
        getExchangeRate()
    }
    
    // MARK: - Actions
    
    @objc
    private func appDidBecomeActive() {
        getExchangeRate()
    }
}
