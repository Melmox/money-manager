//
//  AddTransactionPresenter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol AddTransactionActions: AnyObject {
    func didTapBtChooseCategory()
    func didTapBtAdd()
}

protocol IAddTransactionPresenter {
    func viewDidLoad()
}

final class AddTransactionPresenter: IAddTransactionPresenter, AddTransactionActions {

    
    // MARK: - Properties
    
    weak var view: IAddTransactionViewController?
    private var viewModelFactory: IAddTransactionViewModelFactory
    private let router: IAddTransactionRouter
    private var amount: Double?
    
    // MARK: - Initialization
    
    init(viewModelFactory: IAddTransactionViewModelFactory, router: IAddTransactionRouter) {
        self.viewModelFactory = viewModelFactory
        self.router = router        
    }
    
    // MARK: - Private Functions
    
    
    // MARK: - IAddTransactionPresenter
    
    func viewDidLoad() {
        view?.setup(with: viewModelFactory.makeViewModel(actions: self))
    }
    
    // MARK: - AddTransactionActions
    
    func didTapBtChooseCategory() {
        print("didTapBtChooseCategory")
    }
    
    func didTapBtAdd() {
        print("didTapBtAdd")
    }
}
