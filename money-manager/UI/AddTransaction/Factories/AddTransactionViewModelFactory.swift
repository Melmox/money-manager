//
//  AddTransactionViewModelFactory.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IAddTransactionViewModelFactory {
    func makeViewModel(actions: AddTransactionActions, amount: String?, category: Category?) -> AddTransactionViewModel
}

final class AddTransactionViewModelFactory: IAddTransactionViewModelFactory {
    
    var balance: Double?
    
    // MARK: - IAddTransactionViewModelFactory

    func makeViewModel(actions: AddTransactionActions, amount: String?, category: Category?) -> AddTransactionViewModel {
        .init(tfAmount: tfAmountModel(amount: amount),
              btChooseCategory: btChooseCategoryModel(category: category),
              btChooseCategoryUiMenu: btChooseCategoryUiMenuModel(actions: actions),
              btAdd: btAddModel(actions: actions))
    }
    
    // MARK: - Private Functions
              
    private func tfAmountModel(amount: String?) -> TextFieldViewModel {
        .init(style: .primary,
              text: amount ?? "",
              keyboardType: .decimalPad,
              returnKeyType: .default,
              placeholderText: "Enter amount",
              isSecureTextEntry: false,
              withAutocomplete: false)
    }
    
    private func btChooseCategoryModel(category: Category?) -> ButtonViewModel {
        .init(style: .primary, title: category?.rawValue ?? "Choose Category", action: {})
    }
    
    private func btChooseCategoryUiMenuModel(actions: AddTransactionActions) -> ButtonUiMenuModel {
        return .init(menuItems: generateUIActions(actions: actions), showsMenuAsPrimaryAction: true)
    }

    private func btAddModel(actions: AddTransactionActions) -> ButtonViewModel {
        .init(style: .primary, title: "Add Transaction", action: { [weak actions] in
            actions?.didTapBtAdd()
        })
    }
    
    private func generateUIActions(actions: AddTransactionActions) -> [UIAction] {
        Category.allCases.map({ category in
            UIAction(title: category.rawValue) { [weak actions, category] _ in
                actions?.didChooseCategory(category: category)
            }
        })
    }
}
