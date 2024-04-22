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
    func topUpBalance(amount: Double?)
    func loadMoreCellViewModels()
    var tableViewModels: [[TransactionCellViewModel]]? { get }
}

protocol MainDelegate: AnyObject {
    func expandBalance(amount: Double?)
    func getBalance() -> Double?
}

final class MainPresenter: IMainPresenter, MainActions, MainDelegate {
    
    // MARK: - Properties
    
    weak var view: IMainViewController?
    private let viewModelFactory: IMainViewModelFactory
    private let router: IMainRouter
    private let exchangeRateService: IExchangeRateService
    private let transactionService: ITransactionService
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
    private(set) var tableViewModels: [[TransactionCellViewModel]]?
    private var cellViewModels: [TransactionCellViewModel] = []
        
    private let limit: Int = 20
    private var offset: Int = 0
    private var numberOfLoadedModels: Int = 0
    private var isNeedToLoadMore: Bool {
        numberOfLoadedModels >= limit
    }
    
    // MARK: - Initialization

    init(viewModelFactory: IMainViewModelFactory, router: IMainRouter, exchangeRateService: IExchangeRateService, transactionService: ITransactionService) {
        self.viewModelFactory = viewModelFactory
        self.router = router
        self.exchangeRateService = exchangeRateService
        self.transactionService = transactionService
        
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
        loadCellViewModels()
        view?.setup(with: viewModelFactory.makeViewModel(actions: self, balance: balance, exchangeRate: exchangeRate))
    }
    
    private func createTransaction(amount: Double?) -> Transaction? {
        guard let amount: Double = amount else {
            view?.showError(TransactionError.emptyAmount)
            return nil
        }
        
        return .init(amount: amount, category: TransactionCategory.other, date: Date())
    }
    
    private func loadCellViewModels() {
        offset = 0
        numberOfLoadedModels = 0
        
        transactionService.getTransactionsWith(offset: offset, limit: limit) { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.numberOfLoadedModels = transactions.count
                self?.offset += transactions.count
                
                self?.cellViewModels = transactions.map({ transaction in
                    return TransactionCellViewModel(transaction: transaction)
                })
                self?.makeViewModelFrom(cellViewModels: self?.cellViewModels)
                
                self?.view?.reloadData()
            case .failure:
                break
            }
        }
    }
    
    private func makeViewModelFrom(cellViewModels: [TransactionCellViewModel]?) {
        guard let cellViewModels = cellViewModels else { return }
        let splitedNotCompleted: [[TransactionCellViewModel]] = cellViewModels.divide(comparator: { lhs, rhs -> Bool in
            lhs.transaction.date.dateString() == rhs.transaction.date.dateString()
        })
        
        tableViewModels = splitedNotCompleted
    }
    
    // MARK: - IMainPresenter
    
    func viewDidLoad() {
        updateView()
    }
    
    func topUpBalance(amount: Double?) {
        if var balance = balance,
           let transaction: Transaction = createTransaction(amount: amount) {
            transactionService.saveTransaction(transaction: transaction) { [weak self] _ in
                balance += amount ?? .zero
                self?.balance = balance
                self?.updateView()
            }
        }
    }
    
    func loadMoreCellViewModels() {
        guard isNeedToLoadMore else { return }
        
        transactionService.getTransactionsWith(offset: offset, limit: limit) { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.numberOfLoadedModels = transactions.count
                self?.offset += transactions.count
                
                self?.cellViewModels.append(contentsOf: transactions.map({ transaction in
                    return TransactionCellViewModel(transaction: transaction)
                }))
                
                self?.makeViewModelFrom(cellViewModels: self?.cellViewModels)
                
                self?.view?.reloadData()
            case .failure:
                break
            }
        }
    }
    
    // MARK: - MainDelegate
    
    func expandBalance(amount: Double?) {
        if var balance = balance {
            balance += amount ?? .zero
            self.balance = balance
            self.updateView()
        }
    }
    
    func getBalance() -> Double? {
        balance
    }
        
    // MARK: - MainActions
    
    func didTapBtTopUpBalance() {
        view?.showTopUpBalanceAlert()
    }
    
    func didTapBtAddTransaction() {
        router.showAddTransactionScreen(mainDelegate: self)
    }
    
    // MARK: - Actions
    
    @objc
    private func appDidBecomeActive() {
        getExchangeRate()
    }
}
