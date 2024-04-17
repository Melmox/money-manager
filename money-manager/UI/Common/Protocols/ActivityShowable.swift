//
//  ActivityShowable.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol ActivityShowable {
    func showActivityIndicator()
    func removeActivityIndicator()
}

extension ActivityShowable where Self: UIViewController {

    func showActivityIndicator() {
        view.showActivityIndicator()
    }

    func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.view.removeActivityIndicator()
        }
    }
}
