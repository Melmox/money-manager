//
//  UIView+Keyboard.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

extension UIView {
    func addTapGestureToHideKeyboard() {
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(endEditing))
        addGestureRecognizer(tapGesture)
    }
}
