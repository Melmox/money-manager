//
//  MainPresenter.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IMainPresenter { }

final class MainPresenter: IMainPresenter {
    
    // MARK: - Properties
    
    weak var view: IMainViewController?
    private let viewModelFactory: IMainViewModelFactory
    private let router: IMainRouter
    
    // MARK: - Initialization

    init(viewModelFactory: IMainViewModelFactory, router: IMainRouter) {
        self.viewModelFactory = viewModelFactory
        self.router = router
    }
}
