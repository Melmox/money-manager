//
//  AddTransactionPresenter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol AddTransactionActions: AnyObject {
    func didChooseCategory(category: TransactionCategory?)
    func didTapBtAdd()
}

protocol IAddTransactionPresenter {
    func viewDidLoad()
    func setNewAmount(amount: String?)
}

final class AddTransactionPresenter: IAddTransactionPresenter, AddTransactionActions {
    
    // MARK: - Properties
    
    weak var view: IAddTransactionViewController?
    private var viewModelFactory: IAddTransactionViewModelFactory
    private var transactionService: ITransactionService
    private let router: IAddTransactionRouter
    private var amount: String?
    private var category: TransactionCategory?
    private weak var delegate: MainDelegate?
    
    // MARK: - Initialization
    
    init(viewModelFactory: IAddTransactionViewModelFactory, transactionService: ITransactionService, router: IAddTransactionRouter, mainDelegate: MainDelegate) {
        self.viewModelFactory = viewModelFactory
        self.transactionService = transactionService
        self.router = router
        self.delegate = mainDelegate
    }
    
    // MARK: - Private Functions
    
    private func updateView() {
        view?.setup(with: viewModelFactory.makeViewModel(actions: self, amount: amount, category: category))
    }
    
    private func createTransaction() -> Transaction? {
        guard let amount: Double = Double(amount ?? ""),
              let category: TransactionCategory = category else { return nil }
        return .init(amount: -amount, category: category, date: Date())
    }
    
    // MARK: - IAddTransactionPresenter
    
    func viewDidLoad() {
        updateView()
    }
    
    func setNewAmount(amount: String?) {
        self.amount = amount
        updateView()
    }
    
    // MARK: - AddTransactionActions
    
    func didChooseCategory(category: TransactionCategory?) {
        self.category = category
        updateView()
    }
    
    func didTapBtAdd() {
        guard let transaction: Transaction = createTransaction() else { return }
        transactionService.saveTransaction(transaction: transaction) { [weak self] _ in
            self?.delegate?.expandBalance(amount: transaction.amount)
            self?.router.closeScreen()
        }
    }
}
