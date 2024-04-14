//
//  UIView+Activity.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

public extension UIView {
    func showActivityIndicator() {
        removeActivityIndicator()
        isUserInteractionEnabled = false

        let vActivity: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        self.addSubview(vActivity)
        vActivity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vActivity.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vActivity.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        vActivity.startAnimating()
    }

    func removeActivityIndicator() {
        if let activityIndicator: UIView = self.subviews.first(where: { $0 is UIActivityIndicatorView }) {
            activityIndicator.removeFromSuperview()
            isUserInteractionEnabled = true
        }
    }
}
