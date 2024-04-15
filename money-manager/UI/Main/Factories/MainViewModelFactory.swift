//
//  MainViewModelFactory.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IMainViewModelFactory {
    func makeViewModel(actions: MainActions, balance: Double?, exchangeRate: String?) -> MainViewModel
}

final class MainViewModelFactory: IMainViewModelFactory {
        
    // MARK: - IMainViewModelFactory

    func makeViewModel(actions: MainActions, balance: Double?, exchangeRate: String?) -> MainViewModel {
        .init(exchangeRate: exchangeRate != nil ? "1 BTC = \(exchangeRate ?? "") USD" : "",
              balance: "Your current balance is \(balance ?? .zero) BTC",
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
