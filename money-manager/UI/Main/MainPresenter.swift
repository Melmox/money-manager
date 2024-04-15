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
    func updateBalance(amount: Double?)
}

final class MainPresenter: IMainPresenter, MainActions {
    
    // MARK: - Properties
    
    weak var view: IMainViewController?
    private let viewModelFactory: IMainViewModelFactory
    private let router: IMainRouter
    private let exchangeRateService: IExchangeRateService
    private let ballanceStorage: IBalanceStorage = BalanceStorage()
    
    private var exchangeRate: String?
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
                self?.setExchangeRateToUSD(bitcoinData: bitcoinData)
                DispatchQueue.main.async {
                    self?.updateView()
                }
            case .failure:
                break
            }
        }
    }
    
    private func setExchangeRateToUSD(bitcoinData: BitcoinData) {
        exchangeRate = bitcoinData.bpi["USD"]?.rate
    }
    
    private func updateView() {
        view?.setup(with: viewModelFactory.makeViewModel(actions: self, balance: balance, exchangeRate: exchangeRate))
    }
    
    // MARK: - IMainPresenter
    
    func viewDidLoad() {
        updateView()
    }
    
    func updateBalance(amount: Double?) {
        if var balance = balance {
            balance += amount ?? .zero
            self.balance = balance
            updateView()
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
