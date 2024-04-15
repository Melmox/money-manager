//
//  AddTransactionPresenter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol AddTransactionActions: AnyObject {
    func didChooseCategory(category: Category?)
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
    private let router: IAddTransactionRouter
    private var amount: String?
    private var category: Category?
    
    // MARK: - Initialization
    
    init(viewModelFactory: IAddTransactionViewModelFactory, router: IAddTransactionRouter) {
        self.viewModelFactory = viewModelFactory
        self.router = router        
    }
    
    // MARK: - Private Functions
    
    
    private func updateView() {
        view?.setup(with: viewModelFactory.makeViewModel(actions: self, amount: amount, category: category))
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
    
    func didChooseCategory(category: Category?) {
        self.category = category
        updateView()
    }
    
    func didTapBtAdd() {
        router.closeScreen()
    }
}
