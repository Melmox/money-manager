//
//  MainViewModelFactory.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IMainViewModelFactory {
    func makeViewModel(actions: MainActions) -> MainViewModel
    var balance: Double? { get set }
}

final class MainViewModelFactory: IMainViewModelFactory {
    
    var balance: Double?
    
    // MARK: - IMainViewModelFactory

    func makeViewModel(actions: MainActions) -> MainViewModel {
        .init(balance: "Your current balance is \(balance ?? .zero) BTC",
              btTopUpBalance: btTopUpBalanceModel(actions: actions),
              btAddTransaction: btAddTransactionModel(actions: actions))
    }
    
    // MARK: - Private Functions
    
    private func btTopUpBalanceModel(actions: MainActions) -> ButtonViewModel {
        .init(style: .primary, title: "Top Up Balance", action: { [weak actions] in
            actions?.didTapBtTopUpBalance()
        })
    }
    
    private func btAddTransactionModel(actions: MainActions) -> ButtonViewModel {
        .init(style: .primary, title: "Add Transaction", action: { [weak actions] in
            actions?.didTapBtAddTransaction()
        })
    }
}
