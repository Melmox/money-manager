//
//  UITextField+Setup.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

enum TextFieldStyle {
    case primary
}

struct TextFieldViewModel {
    
    let style: TextFieldStyle
    let text: String?
    let keyboardType: UIKeyboardType
    let returnKeyType: UIReturnKeyType
    let placeholderText: String
    let isSecureTextEntry: Bool
    let withAutocomplete: Bool
}

extension UITextField {

    func setup(with viewModel: TextFieldViewModel) {
        apply(style: viewModel.style)

        text = viewModel.text
        keyboardType = viewModel.keyboardType
        returnKeyType = viewModel.returnKeyType
        placeholder = viewModel.placeholderText
        isSecureTextEntry = viewModel.isSecureTextEntry
    }

    private func apply(style: TextFieldStyle) {
        layer.masksToBounds = true
        
        switch style {
        case .primary:
            layer.cornerRadius = 14
            let border: (color: CGColor?, width: CGFloat) = border(for: style)
            layer.borderColor = border.color
            layer.borderWidth = border.width
        }

        self.backgroundColor = backgroundColor(for: style)
    }

    private func backgroundColor(for style: TextFieldStyle) -> UIColor? {
        switch style {
        case .primary:
            return .systemCyan
        }
    }

    private func titleColor(for style: TextFieldStyle) -> UIColor? {
        switch style {
        case .primary:
            return .black
        }
    }

    private func border(for style: TextFieldStyle) -> (color: CGColor?, width: CGFloat) {
        switch style {
        case .primary:
            return (UIColor.black.cgColor, 1)
        }
    }
}
