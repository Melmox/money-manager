//
//  AddTransactionViewModelFactory.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IAddTransactionViewModelFactory {
    func makeViewModel(actions: AddTransactionActions) -> AddTransactionViewModel
}

final class AddTransactionViewModelFactory: IAddTransactionViewModelFactory {
    
    var balance: Double?
    
    // MARK: - IAddTransactionViewModelFactory

    func makeViewModel(actions: AddTransactionActions) -> AddTransactionViewModel {
        .init(tfAmount: tfAmountModel(), btChooseCategory: btChooseCategoryModel(actions: actions), btAdd: btAddModel(actions: actions))
    }
    
    // MARK: - Private Functions
              
    private func tfAmountModel() -> TextFieldViewModel {
        .init(style: .primary,
              text: "",
              keyboardType: .decimalPad,
              returnKeyType: .default,
              placeholderText: "Enter amount of transaction",
              isSecureTextEntry: false,
              withAutocomplete: false)
    }
    
    private func btChooseCategoryModel(actions: AddTransactionActions) -> ButtonViewModel {
        .init(style: .primary, title: "Choose Category", action: { [weak actions] in
            actions?.didTapBtChooseCategory()
        })
    }

    private func btAddModel(actions: AddTransactionActions) -> ButtonViewModel {
        .init(style: .primary, title: "Add Transaction", action: { [weak actions] in
            actions?.didTapBtAdd()
        })
    }
}
