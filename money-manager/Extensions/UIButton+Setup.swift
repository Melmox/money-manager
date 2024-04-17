//
//  UIButton+Setup.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

enum ButtonStyle {
    case primary
}

struct ButtonViewModel {
    let style: ButtonStyle
    let title: String?
    let action: () -> Void

    init(
        style: ButtonStyle,
        title: String? = nil,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.title = title
        self.action = action
    }
}

struct ButtonUiMenuModel {
    let menuTitle: String?
    let menuItems: [UIAction]
    let showsMenuAsPrimaryAction: Bool
    
    init(menuTitle: String? = nil, menuItems: [UIAction], showsMenuAsPrimaryAction: Bool) {
        self.menuTitle = menuTitle
        self.menuItems = menuItems
        self.showsMenuAsPrimaryAction = showsMenuAsPrimaryAction
    }
}

extension UIButton {

    func setup(with viewModel: ButtonViewModel) {
        apply(style: viewModel.style)
        setTitle(viewModel.title, for: .normal)
        primaryActionClosure = viewModel.action
    }

    private func apply(style: ButtonStyle) {
        layer.masksToBounds = true
        
        switch style {
        case .primary:
            layer.cornerRadius = 14
            let border: (color: CGColor?, width: CGFloat) = border(for: style)
            layer.borderColor = border.color
            layer.borderWidth = border.width
        }

        setTitleColor(titleColor(for: style), for: .normal)
        self.backgroundColor = backgroundColor(for: style)
    }

    private func backgroundColor(for style: ButtonStyle) -> UIColor? {
        switch style {
        case .primary:
            return .systemCyan
        }
    }

    private func titleColor(for style: ButtonStyle) -> UIColor? {
        switch style {
        case .primary:
            return .black
        }
    }

    private func border(for style: ButtonStyle) -> (color: CGColor?, width: CGFloat) {
        switch style {
        case .primary:
            return (UIColor.black.cgColor, 1)
        }
    }
}

extension UIButton {
    func setup(with viewModel: ButtonUiMenuModel) {
        showsMenuAsPrimaryAction = viewModel.showsMenuAsPrimaryAction
        menu = UIMenu(title: viewModel.menuTitle ?? "", children: viewModel.menuItems)
    }
}
