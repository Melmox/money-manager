//
//  MainPresenter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation
import UIKit

protocol MainActions: AnyObject {
    func didTapBtTopUpBalance()
    func didTapBtAddTransaction()
}

protocol IMainPresenter {
    func viewDidLoad()
    func updateBalance(newBalance: Double?)
}

final class MainPresenter: IMainPresenter, MainActions {
    
    // MARK: - Properties
    
    weak var view: IMainViewController?
    private var viewModelFactory: IMainViewModelFactory
    private let router: IMainRouter
    private let exchangeRateService: IExchangeRateService
    private let ballanceStorage: IBalanceStorage = BalanceStorage()
    
    private var balance: Double? {
        get {
            return ballanceStorage.getBalance()
        }
        set(newBalance) {
            ballanceStorage.saveBalance(newBalance)
        }
    }
    
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
            case .success(let bitcoinData):
                self?.view?.updateExchangeRateInLabel(exchangeRate: self?.getExchangeRateToUSD(bitcoinData: bitcoinData))
            case .failure:
                break
            }
        }
    }
    
    private func getExchangeRateToUSD(bitcoinData: BitcoinData) -> String? {
        bitcoinData.bpi["USD"]?.rate
    }
    
    // MARK: - IMainPresenter
    
    func viewDidLoad() {
        viewModelFactory.balance = balance
        view?.setup(with: viewModelFactory.makeViewModel(actions: self))
        getExchangeRate()
    }
    
    func updateBalance(newBalance: Double?) {
        if balance != nil {
            balance! += newBalance ?? .zero // swiftlint:disable:this force_unwrapping
            view?.updateBalanceLabel(balance: balance)
        }
    }
        
    // MARK: - MainActions
    
    func didTapBtTopUpBalance() {
        view?.showTopUpBalanceAlert()
    }
    
    func didTapBtAddTransaction() {
        print("didTapBtAddTransaction")
    }
    
    // MARK: - Actions
    
    @objc
    private func appDidBecomeActive() {
        getExchangeRate()
    }
}
